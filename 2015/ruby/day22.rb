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

class Player
  extend T::Sig

  sig { returns(Integer) }
  attr_reader :hp

  sig { returns(Integer) }
  attr_reader :mana

  sig { returns(Integer) }
  attr_reader :ac

  sig { params(hp: Integer, mana: Integer, ac: Integer).void }
  def initialize(hp:, mana:, ac: 0)
    @hp = hp
    @mana = mana
    @ac = ac
  end

  sig { params(hp: Integer, mana: Integer, ac: Integer).returns(Player) }
  def with(hp: self.hp, mana: self.mana, ac: self.ac)
    Player.new(hp: hp, mana: mana, ac: ac)
  end

  sig { void }
  def print
    puts "- Player has #{hp} hit points, #{ac} armor, #{mana} mana"
  end
end

class Boss < T::Struct
  extend T::Sig

  const :hp, Integer
  const :dmg, Integer

  sig { void }
  def print
    puts "- Boss has #{hp} hit points"
  end
end

Effect = T.type_alias { T.any(PoisionEffect, ShieldEffect, RechargeEffect) }
SpellSeq = T.type_alias { T::Array[Spell] }
GameResult = T.type_alias { T.any(GameState, Player, Boss, NilClass) }

class GameState
  extend T::Sig

  sig { returns(Player) }
  attr_reader :player

  sig { returns(Boss) }
  attr_reader :boss

  sig { returns(T::Array[Effect]) }
  attr_reader :active_effects

  sig { returns(Integer) }
  attr_reader :round

  sig do
    params(
      player: Player,
      boss: Boss,
      active_effects: T::Array[Effect],
      round: Integer
    ).void
  end
  def initialize(player:, boss:, active_effects: [], round: 1)
    @player = player
    @boss = boss
    @active_effects = active_effects
    @round = round
  end

  sig do
    params(
      player: Player,
      boss: Boss,
      active_effects: T::Array[Effect],
      round: Integer
    ).returns(GameState)
  end
  def with(player: self.player, boss: self.boss, active_effects: self.active_effects, round: self.round)
    GameState.new(
      player: player,
      boss: boss,
      active_effects: active_effects,
      round: round
    )
  end

  sig { returns(GameResult) }
  def winner
    return player if boss.hp <= 0
    return boss if player.hp <= 0
    return boss if player.mana <= 0

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
    puts '-- Player turn --'
    # puts "-- Player turn (#{game_state.round}) --"
    game_state.player.print
    game_state.boss.print
    game_state = apply_effects(game_state)
    return T.must(game_state.winner) if game_state.winner

    game_state = cast_spell(game_state, spell)
    game_state = next_turn(game_state)
    return T.must(game_state.winner) if game_state.winner

    # puts "-- Boss turn (#{game_state.round}) --"
    puts '-- Boss turn --'
    game_state.player.print
    game_state.boss.print
    game_state = apply_effects(game_state)
    return T.must(game_state.winner) if game_state.winner

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
  game_state.with(round: game_state.round + 1)
end

sig do
  params(
    game_state: GameState
  ).returns(GameState)
end
def boss_turn(game_state)
  effective_dmg = [game_state.boss.dmg - game_state.player.ac, 1].max
  puts "Boss attacks for #{effective_dmg} damage."
  game_state.with(
    player: game_state.player.with(
      hp: game_state.player.hp - effective_dmg
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
  player = player.with(mana: player.mana - mana_costs(spell))
  game_state = game_state.with(player: player)

  case spell
  when Spell::MagicMissile
    puts 'Player casts MagicMissile dealing 4 damage.'
    game_state.with(boss: boss.with(hp: boss.hp - 4))
  when Spell::Drain
    puts 'Player casts Drain dealing 2 damage and healing 2.'
    game_state.with(
      boss: boss.with(hp: boss.hp - 2),
      player: player.with(hp: player.hp + 2)
    )
  when Spell::Shield
    puts 'Player casts Shield.'
    game_state.with(
      active_effects: append_active_effect_only(
        game_state.active_effects,
        ShieldEffect.new(remaining_rounds: 6)
      )
    )
  when Spell::Poison
    puts 'Player casts Poison.'
    game_state.with(
      active_effects: append_active_effect_only(
        game_state.active_effects,
        PoisionEffect.new(remaining_rounds: 6)
      )
    )
  when Spell::Recharge
    puts 'Player casts Recharge.'
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

sig { params(spell: Spell).returns(Integer) }
def mana_costs(spell)
  case spell
  when Spell::MagicMissile
    53
  when Spell::Drain
    73
  when Spell::Shield
    113
  when Spell::Poison
    173
  when Spell::Recharge
    229
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
    player: game_state.player.with(
      ac: 0
    )
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
        puts "Poison deals #{POISON_DMG} damage; its timer is now #{new_effect.remaining_rounds}."
        GameState.new(
          active_effects: active_effects,
          player: player,
          boss: boss.with(hp: boss.hp - POISON_DMG)
        )
      when ShieldEffect
        puts "Shild sets player AC to #{SHIELD_AC}; its timer is now #{new_effect.remaining_rounds}."
        state.with(
          active_effects: active_effects,
          player: player.with(ac: SHIELD_AC),
          boss: boss.with(hp: boss.hp - POISON_DMG)
        )
      when RechargeEffect
        puts "Recharge adds #{MANA_RECHARGE} mana; its timer is now #{new_effect.remaining_rounds}."
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

sig { returns(GameResult) }
def example1
  simulate(
    GameState.new(
      player: Player.new(hp: 10, mana: 250, ac: 0),
      boss: Boss.new(hp: 13, dmg: 8)
    ),
    [Spell::Poison, Spell::MagicMissile]
  )
end

sig { returns(GameResult) }
def example2
  simulate(
    GameState.new(
      player: Player.new(hp: 10, mana: 250, ac: 0),
      boss: Boss.new(hp: 14, dmg: 8)
    ),
    [
      Spell::Recharge,
      Spell::Shield,
      Spell::Drain,
      Spell::Poison,
      Spell::MagicMissile
    ]
  )
end

# pp ['example1', example1]
pp ['example2', example2]
