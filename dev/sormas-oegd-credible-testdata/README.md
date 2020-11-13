# Generation of credible test data for SORMAS-OEGD

An overview can be found in the presentation [presentation/sormas-oegd-credible-testdata.pdf](presentation/sormas-oegd-credible-testdata.pdf).

The scripts consists essentially in three parts:
1. the parameters and functions
2. the reading of input data in [data/in/](data/in/) (the case counts from RKI) and the generating of the data set, wich is stored as RDS, CSV and Excel files in [data/out/](data/out/)
3. the plots, which are stored in [img/](img/)

Parts 2 and 3 are largely independent. Part to is within `if (generate_dataset) {...}`, if `generate_dataset` is `FALSE`, the data set is loaded from the RDS files to be used for the plots.

The content of [img/](img/) is made available to project partners in a private online repository. (It is too large to be uploaded here and is an output of the script.)

Overall it takes about 20 minutes to generate the data set and about 20 minutes as well for the plots of 315 graph components.

N.B. random seeds are not set (yet) so that each run please produce different results.

## Issues and improvements

### Limitations

Not simulations or scenarios! Rather "play" and demonstration  data: also readability (e.g., clusters are local), but risk of bias and reinforcement of preconception. Hence the parameter correspond to use cases, not epidemic situations

### Adding new fields for a more complete data set

Addresses:
- assign a proper address to each geolocation, e.g., through the Google Maps API 

Tests, quarantine, isolation:
- tested persons as fourth person category besides case, contact and participant (one person can be any number of those at the same time)
- time and result of test
- type of quarantine (at home, in institution)
- whether a case is in isolation
- dates of isolation/quarantine start and end

Occupation/setting of a person, an infection, an event, especially according "household", screening, and to IfSG definitions (), see RKI's [Epidemiologisches Bulletin](https://www.rki.de/DE/Content/Infekt/EpidBull/epid_bull_node.html) 38/20 and RKI's Lagebricht 

Context:
- place of infection (address, location ,type) 
- type of venue/setting for infection, contact, event  venue, 
- name of event
- date of contact

Hospitalization and death: 
- whether in ICU
- dates of hospitalization start and end
- date of death

Person information:
- phone number
- birth date
- sex: add "divers" category

### More realistic generation process

Data quality:
- (re)introduce missing values, in particular date of onset of disease
- introduce incorrect or implausible values

Age distribution within an age group from local demographics

Hospitalization:
- local statistics but without demographics from DIVI-Intensivregister

Death:
- take aggregated values from corona dashboard: death count and reporting date (?) of death, age and sex
- estimate time of death
- ensure that a dead person cannot be infected, develop symptoms or infect someone

Events:
- pick a case
- draw a location nearby for an event
- draw event size
- draw which participants are already known: p_known * p(dist)
- distribute rest of participants near the event

Transmission and infection dynamics:
- age-dependent susceptibility
- age-dependent infectiosity
- more realistic period of infectiosity
- age-dependent probability of being in a type of place of infection, of contact or event setting 
- transmission risk dependent on contact and event setting type
- contacts between cases follow the same social-contact-matrix based probabilities

Age (and sex?) dependent symptoms:
- extrapolate whether there are symptoms from case definition in SurvStat
- given that one has symptoms, age (and sex?) dependent symptom and age specific probabilities from the literature
- non-cases may also have symptoms (?)

Spread dynamics: 
- not just one retrospective snapshot, but day-to-day changes in reporting, contacts, etc.: a contact can get sick, contacted, be tested (negtive or positive > case), go into quarantine...

Tests:
- take positive rate into account

### Plots and statistics

Graphs:
- overall properties:
  - 3 types of edges: infection, contact, participation
  - coloring: category + infection/onset/reporting date as gradient of the category color
- case based
- event based
- infection/onset/reporting/event-date based
- prioritization of which contact should be contacted (backward tracing): score based on degree of cases/event size
- summarize/aggregate overall network at the county level (i.e., intercounty), with edge width the sum of edges

Time series:
- stacked case/contact/participants count vs. ?-date (stacked bar, strata with cases in the middle)
- case/death count vs. onset/reporting date, stratified by county, age group, case definition: comparison test data and RKI data
- cumulated size of individual clusters vs. time: cases, cases+contacts, cases+contacts+participants
- longest transmission chain vs. time
- outbreak detection vs. clusters (of say size >= 5)
- symptom count
- proportion of cases in isolation, of contacts in quarantine

Distributions:
- network degree *k*: cases, cases+contacts, cases+contacts+participants
- size of cluster: cases, cases+contacts, cases+contacts+participants
- longest chain of infection/contacts per component
- number of counties / cluster: cases, cases+contact, cases+contacts+participants
- size of transmission chain
- comparison with random, small-world or (hierarchical) scale-free networks
- age, sex: cases, cases+contacts, overall population
- geographical distance of individual edges: cases, cases+contact, cases+contacts+participants
- serial interval

Summary indicators:
- community R vs. infection date
- K
- percentage cases responsible for x% of infections (typically x=80)

Modelling:
- SEIR à la Althaus: under-reporting

## Session information

## Authors

## License