# typed: strong
# frozen_string_literal: true

require 'sorbet-runtime'

extend T::Sig

BOSS_HP = 71
BOSS_DMG = 10

# Your spells are Magic Missile, Drain, Shield, Poison, and Recharge.
# Magic Missile costs 53 mana. It instantly does 4 damage.
# Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
# Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
# Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
# Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.
class Spell < T::Enum
  enums do
    MagicMissile = new
    Drain = new
    Shield = new
    Poison = new
    Recharge = new
  end
end

class PoisionEffect < T::Struct
  const :remaining_rounds, Integer
end

class ShieldEffect < T::Struct
  const :remaining_rounds, Integer
end

class RechargeEffect < T::Struct
  const :remaining_rounds, Integer
end

class Player < T::Struct
  const :hp, Integer
  const :mana, Integer
  const :ac, Integer, default: 0
end

class Boss < T::Struct
  const :hp, Integer
  const :dmg, Integer
end

Effect = T.type_alias { T.any(PoisionEffect, ShieldEffect, RechargeEffect) }
SpellSeq = T.type_alias { T::Array[Spell] }

class GameState < T::Struct
  extend T::Sig

  const :player, Player
  const :boss, Boss
  const :active_effects, T::Array[Effect], default: []
  const :round, Integer, default: 0

  sig { returns(T.any(Player, Boss, NilClass)) }
  def winner
    return player if boss.hp <= 0
    return boss if player.hp <= 0
    return boss if player.mana < 53

    nil
  end
end

# Simulate the game with the given player, boss and spell sequence.
# Returns the player if they win, or the boss if they win.
# The player wins if the boss's hp reaches 0 before the player's hp reaches 0.
# The boss wins if the player's hp reaches 0 before the boss's hp reaches 0.

sig do
  params(
    game_state: GameState,
    spell_seq: SpellSeq
  ).returns(T.any(Player, Boss, GameState))
end
def simulate(game_state, spell_seq)
  spell_seq.each do |spell|
    game_state = apply_effects(game_state)
    game_state = cast_spell(game_state, spell)
    game_state = next_turn(game_state)
    return T.must(game_state.winner) if game_state.winner

    game_state = apply_effects(game_state)
    game_state = boss_turn(game_state)
    game_state = next_turn(game_state)
    return T.must(game_state.winner) if game_state.winner
  end

  game_state
end

POISON_DMG = 3
SHIELD_AC = 7
MANA_RECHARGE = 101

sig { params(game_state: GameState).returns(GameState) }
def next_turn(game_state)
  pp game_state
  game_state.with(round: game_state.round + 1)
end

sig do
  params(
    game_state: GameState
  ).returns(GameState)
end
def boss_turn(game_state)
  game_state.with(
    player: game_state.player.with(
      hp: game_state.player.hp - [game_state.boss.dmg - game_state.player.ac, 1].max
    )
  )
end

sig do
  params(
    game_state: GameState,
    spell: Spell
  ).returns(GameState)
end
def cast_spell(game_state, spell)
  boss = game_state.boss
  player = game_state.player

  case spell
  when Spell::MagicMissile
    game_state.with(boss: boss.with(hp: boss.hp - 4))
  when Spell::Drain
    game_state.with(
      boss: boss.with(hp: boss.hp - 2),
      player: player.with(hp: player.hp + 2)
    )
  when Spell::Shield
    game_state.with(
      active_effects: append_active_effect_only(
        game_state.active_effects,
        ShieldEffect.new(remaining_rounds: 6)
      )
    )
  when Spell::Poison
    game_state.with(
      active_effects: append_active_effect_only(
        game_state.active_effects,
        PoisionEffect.new(remaining_rounds: 6)
      )
    )
  when Spell::Recharge
    game_state.with(
      active_effects: append_active_effect_only(
        game_state.active_effects,
        RechargeEffect.new(remaining_rounds: 5)
      )
    )
  else
    T.absurd(spell)
  end
end

sig do
  params(game_state: GameState)
    .returns(GameState)
end
def apply_effects(game_state)
  starting_state = game_state.with(
    active_effects: [],
    # reset AC, it will only be increased if the shield effect is active
    player: game_state.player.with(ac: 0)
  )

  T.let(
    game_state.active_effects.inject(starting_state) do |state, effect| # rubocop:disable Metrics/BlockLength
      state = T.let(state, GameState)
      player = game_state.player
      boss = game_state.boss

      new_effect = effect.with(remaining_rounds: effect.remaining_rounds - 1)
      active_effects = append_active_effect_only(state.active_effects, new_effect)

      case effect
      when PoisionEffect
        state.with(
          active_effects: active_effects,
          player: player,
          boss: boss.with(hp: boss.hp - POISON_DMG)
        )
      when ShieldEffect
        state.with(
          active_effects: active_effects,
          player: player.with(ac: SHIELD_AC),
          boss: boss.with(hp: boss.hp - POISON_DMG)
        )
      when RechargeEffect
        state.with(
          active_effects: active_effects,
          player: player.with(mana: player.mana + MANA_RECHARGE),
          boss: boss
        )
      else
        T.absurd(effect)
      end
    end,
    GameState
  )
end

sig { params(active_effects: T::Array[Effect], new_effect: Effect).returns(T::Array[Effect]) }
def append_active_effect_only(active_effects, new_effect)
  still_active?(new_effect) ? active_effects + [new_effect] : active_effects
end

sig { params(effect: Effect).returns(T::Boolean) }
def still_active?(effect)
  effect.remaining_rounds > 0
end

sig { void }
def part1
  # game_state = GameState.new(
  #   player: Player.new(hp: 10, mana: 250, ac: 0),
  #   boss: Boss.new(hp: 13, dmg: 8)
  # )
  #
  # pp game_state.with(player: Player.new(hp: 0, mana: 0, ac: 0))

  simulate(
    GameState.new(
      player: Player.new(hp: 10, mana: 250, ac: 0),
      boss: Boss.new(hp: 13, dmg: 8)
    ),
    [Spell::Poison]
  )
end

part1
