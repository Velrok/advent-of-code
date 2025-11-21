#!/usr/bin/env uvx run
import math

def p1():
    with open('inputs/day01') as file:
        masses = [int(l) for l in file]
        fuels = [math.floor(m / 3) - 2 for m in masses]
        return sum(fuels)

def p2():
    # TODO: this has to be done per line rather then on the p1 result
    payload_fuel = p1()
    remaining_mass = payload_fuel
    fuel_fuel = 0

    while remaining_mass > 0:
        remaining_mass_fuel = max(math.floor(remaining_mass / 3) -2, 0)
        print(f"{remaining_mass}\t-> {remaining_mass_fuel}")
        print(f"{fuel_fuel} + {remaining_mass_fuel} = {fuel_fuel + remaining_mass_fuel}")
        fuel_fuel += remaining_mass_fuel
        remaining_mass = remaining_mass_fuel
        print()

    print(f"{fuel_fuel} + {payload_fuel} = {fuel_fuel + payload_fuel}")
    return fuel_fuel + payload_fuel


# print(p1())
print(p2())
