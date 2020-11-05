import random

from sormas import Disease, SymptomState, SymptomsDto

random.seed(42)

# Symptoms:
# Probabilities of different symptoms given that the person has symptoms..
# Adapted from https://www.theguardian.com/world/2020/oct/19/ ...
# ... coronavirus-symptoms-how-to-tell-if-you-have-a-common-cold-flu-or-covid
# `term` is the term indicated in the article, `prob` the rough, somewhat
# arbitrary translation as a probability.
# `p_asymptomatic` is the probability of no symptom ("asymptomatic",
# 40% in best estimate scenario from CDC on 2020-9-10,
# https://www.cdc.gov/coronavirus/2019-ncov/hcp/planning-scenarios.html#box1 )
# The assignment of symptoms takes RKI's case definition into account, where
# for simplicity "klinisch" means that at least one symptom was observed:
# - case definition A: unknown (there might be symptoms)
# - case definition B: there are symptoms
# - case definition C: there are symptoms
# - case definition D: there are *no* symptoms
# - case definition E: unknown (there might be symptoms)
# Contacts (persons that are not cases) have missing symptoms.
p_asymptomatic = 0.4
# p_symptoms <- tibble(
#  symptom = c("Fieber", "Müdigkeit", "Husten", "Geruchssinnsverlust",
#    "Schmerzen", "Niesen", "Halssschmerz", "Durchfall", "Kopfschmerzen",
#    "Atemnot"),
#  term = c("common", "sometimes", "common", "common", "sometimes", "rare",
#    "sometimes", "rare", "sometimes", "sometimes"),
#  prob = c(0.6, 0.3, 0.6, 0.6, 0.3, 0.1, 0.3, 0.1, 0.3, 0.3)
# )

# todo fever can be extended to actual temperature

# todo not every symptom mapped b/c list is rather long
symptom_distribution = {
    Disease.CORONAVIRUS: {
        'fever': 0.6,
        'cough': 0.6,
        'loss_of_smell': 0.6,
        'sore_throat': 0.3,
        'headache': 0.3
    }
}


def gen_symptom_dto(disease):
    if disease is not Disease.CORONAVIRUS:
        raise NotImplementedError

    distribution = symptom_distribution[disease]

    symptoms = {}

    for pos, prob in distribution.items():
        symptoms[pos] = random.choices([SymptomState.YES, SymptomState.NO], [prob, 1.0 - prob])[0]

    symptom_dto = SymptomsDto(
        **symptoms
    )
    return symptom_dto
