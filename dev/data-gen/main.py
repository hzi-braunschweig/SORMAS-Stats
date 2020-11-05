from datetime import date

from universe.world import World


def main():
    # Set everything up
    # Create our world where we simulate a pandemic. This is our playground.
    # Set a beginning for our world
    world = World(date.fromisoformat('2020-02-01'))

    # Populate default entities in our world
    world.add_region("Wonderland")

    # Populate our world with n persons
    world.populate(n=5)

    # All set! Now we start the pandemic with patient zero
    world.patient_zero()

    # Now we let run the simulation for 5 ticks
    world.simulate(ticks=3)

    # Great, now store the world's case history in SORMAS/JSON/CSV etc
    world.export_sormas()
    # world.export_json()

    pass


if __name__ == '__main__':
    main()
