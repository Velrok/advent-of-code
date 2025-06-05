# typed: strong
# frozen_string_literal: true

require 'sorbet-runtime'

extend T::Sig

class Weapon < T::Struct
  extend T::Sig

  const :cost, Integer
  const :name, String
  const :damage, Integer
end

# Weapons:    Cost  Damage  Armor
# Dagger        8     4       0
# Shortsword   10     5       0
# Warhammer    25     6       0
# Longsword    40     7       0
# Greataxe     74     8       0

WEAPON_OPTIONS = T.let([
  Weapon.new(cost: 8, name: 'Dagger', damage: 4),
  Weapon.new(cost: 10, name: 'Shortsword', damage: 5),
  Weapon.new(cost: 25, name: 'Warhammer', damage: 6),
  Weapon.new(cost: 40, name: 'Longsword', damage: 7),
  Weapon.new(cost: 74, name: 'Greataxe', damage: 8)
], T::Array[Weapon])

# Armor:      Cost  Damage  Armor
# Leather      13     0       1
# Chainmail    31     0       2
# Splintmail   53     0       3
# Bandedmail   75     0       4
# Platemail   102     0       5
class Armour < T::Struct
  extend T::Sig

  const :cost, Integer
  const :name, String
  const :defence, Integer
end

ARMOUR_OPTIONS = T.let([
  Armour.new(cost: 13, name: 'Leather', defence: 1),
  Armour.new(cost: 31, name: 'Chainmail', defence: 2),
  Armour.new(cost: 53, name: 'Splintmail', defence: 3),
  Armour.new(cost: 75, name: 'Bandedmail', defence: 4),
  Armour.new(cost: 102, name: 'Platemail', defence: 5)
], T::Array[Armour])

# Rings:      Cost  Damage  Armor
# Damage +1    25     1       0
# Damage +2    50     2       0
# Damage +3   100     3       0
# Defense +1   20     0       1
# Defense +2   40     0       2
# Defense +3   80     0       3

class Ring < T::Struct
  extend T::Sig

  const :cost, Integer
  const :name, String
  const :damage, Integer
  const :defence, Integer
end

RING_OPTIONS = T.let([
  Ring.new(cost: 25, name: 'Damage +1', damage: 1, defence: 0),
  Ring.new(cost: 50, name: 'Damage +2', damage: 2, defence: 0),
  Ring.new(cost: 100, name: 'Damage +3', damage: 3, defence: 0),
  Ring.new(cost: 20, name: 'Defense +1', damage: 0, defence: 1),
  Ring.new(cost: 40, name: 'Defense +2', damage: 0, defence: 2),
  Ring.new(cost: 80, name: 'Defense +3', damage: 0, defence: 3)
], T::Array[Ring])

class Loadout < T::Struct
  extend T::Sig

  const :weapon, Weapon
  const :armour, T.nilable(Armour)
  const :ring1, T.nilable(Ring)
  const :ring2, T.nilable(Ring)

  sig { returns(Integer) }
  def dmg
    [weapon, ring1, ring2]
      .map { _1&.damage || 0 }
      .sum
  end

  sig { returns(Integer) }
  def defence
    [armour, ring1, ring2]
      .map { _1&.defence || 0 }
      .sum
  end

  sig { returns(Integer) }
  def cost
    [weapon, armour, ring1, ring2]
      .map { _1&.cost || 0 }
      .sum
  end
end

PLAYER_HP = 100
BOSS_HP = 100
BOSS_DMG = 8
BOSS_DEF = 2

sig { params(loadout: Loadout).returns(T::Boolean) }
def winner?(loadout)
  payer_death_rounds = PLAYER_HP / [(BOSS_DMG - loadout.defence), 1].max.to_f
  boss_death_rounds = BOSS_HP / [(loadout.dmg - BOSS_DEF), 1].max.to_f
  # pp [loadout, loadout.cost, boss_death_rounds, payer_death_rounds]

  boss_death_rounds <= payer_death_rounds
end

sig { returns(T::Array[Loadout]) }
def all_possible_loadouts
  WEAPON_OPTIONS.flat_map do |weapon|
    ARMOUR_OPTIONS.concat([nil]).flat_map do |armour|
      ring_combos = RING_OPTIONS.concat([nil]).combination(2).to_a

      ring_combos.flat_map do |ring1, ring2|
        Loadout.new(
          weapon:,
          armour:,
          ring1:,
          ring2:
        )
      end
    end
  end.sort_by(&:cost)
end

sig {void}
def part1
  # pp all_possible_loadouts
  cheapest_loadout = all_possible_loadouts.find {|l| winner?(l)}
  pp cheapest_loadout
end

sig {void}
def part2
  pp all_possible_loadouts
    .sort_by {-_1.cost}
    .find {|l| !winner?(l)}
end


part2
