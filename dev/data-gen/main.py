from datetime import date

from universe.world import World


# todo ### Data ---- should be done beforehand and fixed as parameters

def main():
    # Set everything up
    # Create our world where we simulate a pandemic. This is our playground.
    # Set a beginning for our world
    world = World(date.fromisoformat('2020-02-01'))

    # Populate default entities in our world
    # Counties of interest
    world.add_district("Braunschweig")
    world.add_district("Salzgitter")
    world.add_district("Wolfsburg")

    # Populate our world with n persons
    #world.populate_susceptible(n=5)
    world.populate_cases(n=3)

    world.populate_infection_chains() #todo
    world.populate_contacts() # todo
    #  ### Geolocations --- todo don't know yet
    world.populate_events()   # todo







    # All set! Now we start the pandemic with patient zero
    # world.patient_zero()
    # Now we let run the simulation for 5 ticks
    #world.simulate(ticks=3)

    # Great, now store the world's case history in SORMAS/JSON/CSV etc
    world.export_sormas()
    # world.export_json()

    pass


if __name__ == '__main__':
    main()
