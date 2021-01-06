from django.db import models

# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from stats.models import SormasModel


class ActionHistory(SormasModel):
    reply = models.CharField(max_length=4096, blank=True, null=True)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    description = models.CharField(max_length=4096, blank=True, null=True)
    date = models.DateTimeField(blank=True, null=True)
    statuschangedate = models.DateTimeField(blank=True, null=True)
    actioncontext = models.CharField(max_length=512, blank=True, null=True)
    actionstatus = models.CharField(max_length=512, blank=True, null=True)
    uuid = models.CharField(max_length=36)
    event_id = models.BigIntegerField(blank=True, null=True)
    creatoruser_id = models.BigIntegerField(blank=True, null=True)
    priority = models.CharField(max_length=512, blank=True, null=True)
    replyinguser_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    title = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'action_history'


class AdditionaltestHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    sample_id = models.BigIntegerField()
    testdatetime = models.DateTimeField()
    haemoglobinuria = models.CharField(max_length=255, blank=True, null=True)
    proteinuria = models.CharField(max_length=255, blank=True, null=True)
    hematuria = models.CharField(max_length=255, blank=True, null=True)
    arterialvenousgasph = models.FloatField(blank=True, null=True)
    arterialvenousgaspco2 = models.FloatField(blank=True, null=True)
    arterialvenousgaspao2 = models.FloatField(blank=True, null=True)
    arterialvenousgashco3 = models.FloatField(blank=True, null=True)
    gasoxygentherapy = models.FloatField(blank=True, null=True)
    altsgpt = models.FloatField(blank=True, null=True)
    astsgot = models.FloatField(blank=True, null=True)
    creatinine = models.FloatField(blank=True, null=True)
    potassium = models.FloatField(blank=True, null=True)
    urea = models.FloatField(blank=True, null=True)
    haemoglobin = models.FloatField(blank=True, null=True)
    totalbilirubin = models.FloatField(blank=True, null=True)
    conjbilirubin = models.FloatField(blank=True, null=True)
    wbccount = models.FloatField(blank=True, null=True)
    platelets = models.FloatField(blank=True, null=True)
    prothrombintime = models.FloatField(blank=True, null=True)
    othertestresults = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'additionaltest_history'


class AggregatereportHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    reportinguser_id = models.BigIntegerField(blank=True, null=True)
    region_id = models.BigIntegerField(blank=True, null=True)
    district_id = models.BigIntegerField(blank=True, null=True)
    healthfacility_id = models.BigIntegerField(blank=True, null=True)
    pointofentry_id = models.BigIntegerField(blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    year = models.IntegerField(blank=True, null=True)
    epiweek = models.IntegerField(blank=True, null=True)
    newcases = models.IntegerField(blank=True, null=True)
    labconfirmations = models.IntegerField(blank=True, null=True)
    deaths = models.IntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'aggregatereport_history'


class Areas(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=512, blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'areas'


class Region(SormasModel):
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=36)
    epidcode = models.CharField(max_length=255, blank=True, null=True)
    growthrate = models.FloatField(blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)
    area = models.ForeignKey(Areas, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'region'


class AreasHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=512, blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'areas_history'


class CampaignCampaignformmetaHistory(SormasModel):
    campaign_id = models.BigIntegerField()
    campaignformmeta_id = models.BigIntegerField()
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'campaign_campaignformmeta_history'


class Campaigndiagramdefinition(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    diagramid = models.CharField(unique=True, max_length=255)
    diagramtype = models.CharField(max_length=255, blank=True, null=True)
    campaigndiagramseries = models.TextField(blank=True, null=True)  # This field type is a guess.
    sys_period = models.TextField()  # This field type is a guess.
    diagramcaption = models.CharField(max_length=255, blank=True, null=True)
    campaignseriestotal = models.TextField(blank=True, null=True)  # This field type is a guess.
    percentagedefault = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'campaigndiagramdefinition'


class CampaigndiagramdefinitionHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    diagramid = models.CharField(max_length=255)
    diagramtype = models.CharField(max_length=255, blank=True, null=True)
    campaigndiagramseries = models.TextField(blank=True, null=True)  # This field type is a guess.
    sys_period = models.TextField()  # This field type is a guess.
    diagramcaption = models.CharField(max_length=255, blank=True, null=True)
    campaignseriestotal = models.TextField(blank=True, null=True)  # This field type is a guess.
    percentagedefault = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'campaigndiagramdefinition_history'


class CampaignformdataHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    formvalues = models.TextField(blank=True, null=True)  # This field type is a guess.
    campaign_id = models.BigIntegerField()
    campaignformmeta_id = models.BigIntegerField()
    region_id = models.BigIntegerField()
    district_id = models.BigIntegerField()
    community_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    archived = models.BooleanField(blank=True, null=True)
    formdate = models.DateTimeField(blank=True, null=True)
    creatinguser_id = models.BigIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'campaignformdata_history'


class Campaignformmeta(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    formid = models.CharField(max_length=255, blank=True, null=True)
    languagecode = models.CharField(max_length=255, blank=True, null=True)
    campaignformelements = models.TextField(blank=True, null=True)  # This field type is a guess.
    sys_period = models.TextField()  # This field type is a guess.
    formname = models.CharField(max_length=512, blank=True, null=True)
    campaignformtranslations = models.TextField(blank=True, null=True)  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'campaignformmeta'


class CampaignformmetaHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=255, blank=True, null=True)
    description = models.CharField(max_length=4096, blank=True, null=True)
    startdate = models.DateTimeField(blank=True, null=True)
    enddate = models.DateTimeField(blank=True, null=True)
    creatinguser_id = models.BigIntegerField(blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    formname = models.CharField(max_length=512, blank=True, null=True)
    campaignformelements = models.TextField(blank=True, null=True)  # This field type is a guess.
    campaignformtranslations = models.TextField(blank=True, null=True)  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'campaignformmeta_history'

    class Meta:
        managed = False
        db_table = 'campaigns'


class CampaignsHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=255, blank=True, null=True)
    description = models.CharField(max_length=4096, blank=True, null=True)
    startdate = models.DateTimeField(blank=True, null=True)
    enddate = models.DateTimeField(blank=True, null=True)
    creatinguser_id = models.BigIntegerField(blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    dashboardelements = models.TextField(blank=True, null=True)  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'campaigns_history'


class CasesHistory(SormasModel):
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    description = models.CharField(max_length=4096, blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    investigateddate = models.DateTimeField(blank=True, null=True)
    reportdate = models.DateTimeField()
    uuid = models.CharField(max_length=36)
    caseofficer_id = models.BigIntegerField(blank=True, null=True)
    healthfacility_id = models.BigIntegerField(blank=True, null=True)
    reportinguser_id = models.BigIntegerField()
    surveillanceofficer_id = models.BigIntegerField(blank=True, null=True)
    person_id = models.BigIntegerField()
    symptoms_id = models.BigIntegerField(blank=True, null=True)
    region_id = models.BigIntegerField(blank=True, null=True)
    district_id = models.BigIntegerField(blank=True, null=True)
    community_id = models.BigIntegerField(blank=True, null=True)
    caseclassification = models.CharField(max_length=255)
    investigationstatus = models.CharField(max_length=255)
    hospitalization_id = models.BigIntegerField(blank=True, null=True)
    pregnant = models.CharField(max_length=255, blank=True, null=True)
    epidata_id = models.BigIntegerField(blank=True, null=True)
    epidnumber = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    smallpoxvaccinationscar = models.CharField(max_length=255, blank=True, null=True)
    plaguetype = models.CharField(max_length=255, blank=True, null=True)
    smallpoxvaccinationreceived = models.CharField(max_length=255, blank=True, null=True)
    vaccinationdate = models.DateTimeField(blank=True, null=True)
    vaccination = models.CharField(max_length=255, blank=True, null=True)
    vaccinationdoses = models.CharField(max_length=512, blank=True, null=True)
    vaccinationinfosource = models.CharField(max_length=255, blank=True, null=True)
    districtleveldate = models.DateTimeField(blank=True, null=True)
    outcome = models.CharField(max_length=255, blank=True, null=True)
    outcomedate = models.DateTimeField(blank=True, null=True)
    caseage = models.IntegerField(blank=True, null=True)
    systemcaseclassification = models.CharField(max_length=255, blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    therapy_id = models.BigIntegerField(blank=True, null=True)
    clinicalcourse_id = models.BigIntegerField(blank=True, null=True)
    sequelae = models.CharField(max_length=255, blank=True, null=True)
    sequelaedetails = models.CharField(max_length=512, blank=True, null=True)
    regionleveldate = models.DateTimeField(blank=True, null=True)
    nationalleveldate = models.DateTimeField(blank=True, null=True)
    cliniciandetails = models.CharField(max_length=512, blank=True, null=True)
    notifyingclinic = models.CharField(max_length=255, blank=True, null=True)
    notifyingclinicdetails = models.CharField(max_length=512, blank=True, null=True)
    maternalhistory_id = models.BigIntegerField(blank=True, null=True)
    pointofentry_id = models.BigIntegerField(blank=True, null=True)
    pointofentrydetails = models.CharField(max_length=512, blank=True, null=True)
    caseorigin = models.CharField(max_length=255, blank=True, null=True)
    porthealthinfo_id = models.BigIntegerField(blank=True, null=True)
    clinicianphone = models.CharField(max_length=512, blank=True, null=True)
    clinicianemail = models.CharField(max_length=512, blank=True, null=True)
    duplicateof_id = models.BigIntegerField(blank=True, null=True)
    completeness = models.FloatField(blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    vaccine = models.CharField(max_length=512, blank=True, null=True)
    rabiestype = models.CharField(max_length=255, blank=True, null=True)
    additionaldetails = models.CharField(max_length=4096, blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)
    sharedtocountry = models.BooleanField(blank=True, null=True)
    quarantine = models.CharField(max_length=255, blank=True, null=True)
    quarantinefrom = models.DateTimeField(blank=True, null=True)
    quarantineto = models.DateTimeField(blank=True, null=True)
    quarantinehelpneeded = models.CharField(max_length=512, blank=True, null=True)
    quarantineorderedverbally = models.BooleanField(blank=True, null=True)
    quarantineorderedofficialdocument = models.BooleanField(blank=True, null=True)
    quarantineorderedverballydate = models.DateTimeField(blank=True, null=True)
    quarantineorderedofficialdocumentdate = models.DateTimeField(blank=True, null=True)
    quarantinehomepossible = models.CharField(max_length=255, blank=True, null=True)
    quarantinehomepossiblecomment = models.CharField(max_length=512, blank=True, null=True)
    quarantinehomesupplyensured = models.CharField(max_length=255, blank=True, null=True)
    quarantinehomesupplyensuredcomment = models.CharField(max_length=512, blank=True, null=True)
    reportingtype = models.CharField(max_length=255, blank=True, null=True)
    postpartum = models.CharField(max_length=255, blank=True, null=True)
    trimester = models.CharField(max_length=255, blank=True, null=True)
    diseasedetails = models.CharField(max_length=512, blank=True, null=True)
    classificationcomment = models.CharField(max_length=512, blank=True, null=True)
    healthfacilitydetails = models.CharField(max_length=512, blank=True, null=True)
    quarantinetypedetails = models.CharField(max_length=512, blank=True, null=True)
    clinicalconfirmation = models.CharField(max_length=255, blank=True, null=True)
    epidemiologicalconfirmation = models.CharField(max_length=255, blank=True, null=True)
    laboratorydiagnosticconfirmation = models.CharField(max_length=255, blank=True, null=True)
    quarantineextended = models.BooleanField(blank=True, null=True)
    followupstatus = models.CharField(max_length=255, blank=True, null=True)
    followupcomment = models.CharField(max_length=4096, blank=True, null=True)
    followupuntil = models.DateTimeField(blank=True, null=True)
    overwritefollowupuntil = models.BooleanField(blank=True, null=True)
    facilitytype = models.CharField(max_length=255, blank=True, null=True)
    quarantineofficialordersent = models.BooleanField(blank=True, null=True)
    quarantineofficialordersentdate = models.DateTimeField(blank=True, null=True)
    quarantinereduced = models.BooleanField(blank=True, null=True)
    caseidism = models.IntegerField(blank=True, null=True)
    covidtestreason = models.CharField(max_length=255, blank=True, null=True)
    covidtestreasondetails = models.CharField(max_length=512, blank=True, null=True)
    contacttracingfirstcontacttype = models.CharField(max_length=255, blank=True, null=True)
    contacttracingfirstcontactdate = models.DateTimeField(blank=True, null=True)
    quarantinereasonbeforeisolation = models.CharField(max_length=255, blank=True, null=True)
    quarantinereasonbeforeisolationdetails = models.CharField(max_length=512, blank=True, null=True)
    endofisolationreason = models.CharField(max_length=255, blank=True, null=True)
    endofisolationreasondetails = models.CharField(max_length=512, blank=True, null=True)
    wasinquarantinebeforeisolation = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'cases_history'


class ClinicalcourseHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    sys_period = models.TextField()  # This field type is a guess.
    healthconditions_id = models.BigIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'clinicalcourse_history'


class ClinicalvisitHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    clinicalcourse_id = models.BigIntegerField()
    symptoms_id = models.BigIntegerField()
    disease = models.CharField(max_length=255, blank=True, null=True)
    visitdatetime = models.DateTimeField(blank=True, null=True)
    visitremarks = models.CharField(max_length=512, blank=True, null=True)
    visitingperson = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'clinicalvisit_history'


class ContactHistory(SormasModel):
    changedate = models.DateTimeField()
    contactproximity = models.CharField(max_length=255, blank=True, null=True)
    creationdate = models.DateTimeField()
    lastcontactdate = models.DateTimeField(blank=True, null=True)
    reportdatetime = models.DateTimeField()
    uuid = models.CharField(max_length=36)
    caze_id = models.BigIntegerField(blank=True, null=True)
    person_id = models.BigIntegerField()
    reportinguser_id = models.BigIntegerField()
    description = models.CharField(max_length=4096, blank=True, null=True)
    contactofficer_id = models.BigIntegerField(blank=True, null=True)
    contactclassification = models.CharField(max_length=255, blank=True, null=True)
    followupstatus = models.CharField(max_length=255, blank=True, null=True)
    followupuntil = models.DateTimeField(blank=True, null=True)
    relationtocase = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    contactstatus = models.CharField(max_length=255, blank=True, null=True)
    resultingcase_id = models.BigIntegerField(blank=True, null=True)
    resultingcaseuser_id = models.BigIntegerField(blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)
    region_id = models.BigIntegerField(blank=True, null=True)
    district_id = models.BigIntegerField(blank=True, null=True)
    highpriority = models.BooleanField(blank=True, null=True)
    immunosuppressivetherapybasicdisease = models.CharField(max_length=255, blank=True, null=True)
    immunosuppressivetherapybasicdiseasedetails = models.CharField(max_length=512, blank=True, null=True)
    careforpeopleover60 = models.CharField(max_length=255, blank=True, null=True)
    quarantine = models.CharField(max_length=255, blank=True, null=True)
    quarantinefrom = models.DateTimeField(blank=True, null=True)
    quarantineto = models.DateTimeField(blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    diseasedetails = models.CharField(max_length=512, blank=True, null=True)
    caseidexternalsystem = models.CharField(max_length=512, blank=True, null=True)
    caseoreventinformation = models.CharField(max_length=4096, blank=True, null=True)
    contactcategory = models.CharField(max_length=255, blank=True, null=True)
    contactproximitydetails = models.CharField(max_length=512, blank=True, null=True)
    overwritefollowupuntil = models.BooleanField(blank=True, null=True)
    quarantinehelpneeded = models.CharField(max_length=512, blank=True, null=True)
    quarantineorderedverbally = models.BooleanField(blank=True, null=True)
    quarantineorderedofficialdocument = models.BooleanField(blank=True, null=True)
    quarantineorderedverballydate = models.DateTimeField(blank=True, null=True)
    quarantineorderedofficialdocumentdate = models.DateTimeField(blank=True, null=True)
    quarantinehomepossible = models.CharField(max_length=255, blank=True, null=True)
    quarantinehomepossiblecomment = models.CharField(max_length=512, blank=True, null=True)
    quarantinehomesupplyensured = models.CharField(max_length=255, blank=True, null=True)
    quarantinehomesupplyensuredcomment = models.CharField(max_length=512, blank=True, null=True)
    additionaldetails = models.CharField(max_length=4096, blank=True, null=True)
    followupcomment = models.CharField(max_length=4096, blank=True, null=True)
    relationdescription = models.CharField(max_length=512, blank=True, null=True)
    quarantinetypedetails = models.CharField(max_length=512, blank=True, null=True)
    epidata_id = models.BigIntegerField(blank=True, null=True)
    contactidentificationsource = models.CharField(max_length=255, blank=True, null=True)
    contactidentificationsourcedetails = models.CharField(max_length=512, blank=True, null=True)
    tracingapp = models.CharField(max_length=255, blank=True, null=True)
    tracingappdetails = models.CharField(max_length=512, blank=True, null=True)
    quarantineextended = models.BooleanField(blank=True, null=True)
    community_id = models.BigIntegerField(blank=True, null=True)
    quarantineofficialordersent = models.BooleanField(blank=True, null=True)
    quarantineofficialordersentdate = models.DateTimeField(blank=True, null=True)
    quarantinereduced = models.BooleanField(blank=True, null=True)
    endofquarantinereason = models.CharField(max_length=255, blank=True, null=True)
    endofquarantinereasondetails = models.CharField(max_length=512, blank=True, null=True)
    returningtraveler = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'contact_history'


class ContactsVisitsHistory(SormasModel):
    contact_id = models.BigIntegerField()
    visit_id = models.BigIntegerField()
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'contacts_visits_history'


class Diseaseconfiguration(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    disease = models.CharField(max_length=255, blank=True, null=True)
    active = models.BooleanField(blank=True, null=True)
    primarydisease = models.BooleanField(blank=True, null=True)
    followupenabled = models.BooleanField(blank=True, null=True)
    followupduration = models.IntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    casebased = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'diseaseconfiguration'


class DiseaseconfigurationHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    disease = models.CharField(max_length=255, blank=True, null=True)
    active = models.BooleanField(blank=True, null=True)
    primarydisease = models.BooleanField(blank=True, null=True)
    followupenabled = models.BooleanField(blank=True, null=True)
    followupduration = models.IntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    casebased = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'diseaseconfiguration_history'


class District(SormasModel):
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=36)
    region = models.ForeignKey(Region, models.DO_NOTHING)
    epidcode = models.CharField(max_length=255, blank=True, null=True)
    growthrate = models.FloatField(blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'district'


class Community(SormasModel):
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=36)
    district = models.ForeignKey(District, models.DO_NOTHING)
    archived = models.BooleanField(blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'community'


class Epidata(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    rodents = models.CharField(max_length=255, blank=True, null=True)
    bats = models.CharField(max_length=255, blank=True, null=True)
    primates = models.CharField(max_length=255, blank=True, null=True)
    swine = models.CharField(max_length=255, blank=True, null=True)
    birds = models.CharField(max_length=255, blank=True, null=True)
    eatingrawanimals = models.CharField(max_length=255, blank=True, null=True)
    sickdeadanimals = models.CharField(max_length=255, blank=True, null=True)
    sickdeadanimalsdetails = models.CharField(max_length=512, blank=True, null=True)
    sickdeadanimalsdate = models.DateTimeField(blank=True, null=True)
    sickdeadanimalslocation = models.CharField(max_length=512, blank=True, null=True)
    cattle = models.CharField(max_length=255, blank=True, null=True)
    otheranimals = models.CharField(max_length=255, blank=True, null=True)
    otheranimalsdetails = models.CharField(max_length=512, blank=True, null=True)
    watersource = models.CharField(max_length=255, blank=True, null=True)
    watersourceother = models.CharField(max_length=512, blank=True, null=True)
    waterbody = models.CharField(max_length=255, blank=True, null=True)
    waterbodydetails = models.CharField(max_length=512, blank=True, null=True)
    tickbite = models.CharField(max_length=255, blank=True, null=True)
    burialattended = models.CharField(max_length=255, blank=True, null=True)
    gatheringattended = models.CharField(max_length=255, blank=True, null=True)
    traveled = models.CharField(max_length=255, blank=True, null=True)
    changedateofembeddedlists = models.DateTimeField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    dateoflastexposure = models.DateTimeField(blank=True, null=True)
    placeoflastexposure = models.CharField(max_length=512, blank=True, null=True)
    animalcondition = models.CharField(max_length=255, blank=True, null=True)
    fleabite = models.CharField(max_length=255, blank=True, null=True)
    directcontactconfirmedcase = models.CharField(max_length=255, blank=True, null=True)
    directcontactprobablecase = models.CharField(max_length=255, blank=True, null=True)
    closecontactprobablecase = models.CharField(max_length=255, blank=True, null=True)
    areaconfirmedcases = models.CharField(max_length=255, blank=True, null=True)
    processingconfirmedcasefluidunsafe = models.CharField(max_length=255, blank=True, null=True)
    percutaneouscaseblood = models.CharField(max_length=255, blank=True, null=True)
    directcontactdeadunsafe = models.CharField(max_length=255, blank=True, null=True)
    processingsuspectedcasesampleunsafe = models.CharField(max_length=255, blank=True, null=True)
    areainfectedanimals = models.CharField(max_length=255, blank=True, null=True)
    eatingrawanimalsininfectedarea = models.CharField(max_length=255, blank=True, null=True)
    eatingrawanimalsdetails = models.CharField(max_length=512, blank=True, null=True)
    kindofexposurebite = models.CharField(max_length=255, blank=True, null=True)
    kindofexposuretouch = models.CharField(max_length=255, blank=True, null=True)
    kindofexposurescratch = models.CharField(max_length=255, blank=True, null=True)
    kindofexposurelick = models.CharField(max_length=255, blank=True, null=True)
    kindofexposureother = models.CharField(max_length=255, blank=True, null=True)
    kindofexposuredetails = models.CharField(max_length=512, blank=True, null=True)
    animalvaccinationstatus = models.CharField(max_length=255, blank=True, null=True)
    dogs = models.CharField(max_length=255, blank=True, null=True)
    cats = models.CharField(max_length=255, blank=True, null=True)
    canidae = models.CharField(max_length=255, blank=True, null=True)
    rabbits = models.CharField(max_length=255, blank=True, null=True)
    prophylaxisstatus = models.CharField(max_length=255, blank=True, null=True)
    dateofprophylaxis = models.DateTimeField(blank=True, null=True)
    visitedhealthfacility = models.CharField(max_length=255, blank=True, null=True)
    contactwithsourcerespiratorycase = models.CharField(max_length=255, blank=True, null=True)
    visitedanimalmarket = models.CharField(max_length=255, blank=True, null=True)
    camels = models.CharField(max_length=255, blank=True, null=True)
    snakes = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'epidata'


class EpidataHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    rodents = models.CharField(max_length=255, blank=True, null=True)
    bats = models.CharField(max_length=255, blank=True, null=True)
    primates = models.CharField(max_length=255, blank=True, null=True)
    swine = models.CharField(max_length=255, blank=True, null=True)
    birds = models.CharField(max_length=255, blank=True, null=True)
    eatingrawanimals = models.CharField(max_length=255, blank=True, null=True)
    sickdeadanimals = models.CharField(max_length=255, blank=True, null=True)
    sickdeadanimalsdetails = models.CharField(max_length=512, blank=True, null=True)
    sickdeadanimalsdate = models.DateTimeField(blank=True, null=True)
    sickdeadanimalslocation = models.CharField(max_length=512, blank=True, null=True)
    cattle = models.CharField(max_length=255, blank=True, null=True)
    otheranimals = models.CharField(max_length=255, blank=True, null=True)
    otheranimalsdetails = models.CharField(max_length=512, blank=True, null=True)
    watersource = models.CharField(max_length=255, blank=True, null=True)
    watersourceother = models.CharField(max_length=512, blank=True, null=True)
    waterbody = models.CharField(max_length=255, blank=True, null=True)
    waterbodydetails = models.CharField(max_length=512, blank=True, null=True)
    tickbite = models.CharField(max_length=255, blank=True, null=True)
    burialattended = models.CharField(max_length=255, blank=True, null=True)
    gatheringattended = models.CharField(max_length=255, blank=True, null=True)
    traveled = models.CharField(max_length=255, blank=True, null=True)
    changedateofembeddedlists = models.DateTimeField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    dateoflastexposure = models.DateTimeField(blank=True, null=True)
    placeoflastexposure = models.CharField(max_length=512, blank=True, null=True)
    animalcondition = models.CharField(max_length=255, blank=True, null=True)
    fleabite = models.CharField(max_length=255, blank=True, null=True)
    directcontactconfirmedcase = models.CharField(max_length=255, blank=True, null=True)
    directcontactprobablecase = models.CharField(max_length=255, blank=True, null=True)
    closecontactprobablecase = models.CharField(max_length=255, blank=True, null=True)
    areaconfirmedcases = models.CharField(max_length=255, blank=True, null=True)
    processingconfirmedcasefluidunsafe = models.CharField(max_length=255, blank=True, null=True)
    percutaneouscaseblood = models.CharField(max_length=255, blank=True, null=True)
    directcontactdeadunsafe = models.CharField(max_length=255, blank=True, null=True)
    processingsuspectedcasesampleunsafe = models.CharField(max_length=255, blank=True, null=True)
    areainfectedanimals = models.CharField(max_length=255, blank=True, null=True)
    eatingrawanimalsininfectedarea = models.CharField(max_length=255, blank=True, null=True)
    eatingrawanimalsdetails = models.CharField(max_length=512, blank=True, null=True)
    kindofexposurebite = models.CharField(max_length=255, blank=True, null=True)
    kindofexposuretouch = models.CharField(max_length=255, blank=True, null=True)
    kindofexposurescratch = models.CharField(max_length=255, blank=True, null=True)
    kindofexposurelick = models.CharField(max_length=255, blank=True, null=True)
    kindofexposureother = models.CharField(max_length=255, blank=True, null=True)
    kindofexposuredetails = models.CharField(max_length=512, blank=True, null=True)
    animalvaccinationstatus = models.CharField(max_length=255, blank=True, null=True)
    dogs = models.CharField(max_length=255, blank=True, null=True)
    cats = models.CharField(max_length=255, blank=True, null=True)
    canidae = models.CharField(max_length=255, blank=True, null=True)
    rabbits = models.CharField(max_length=255, blank=True, null=True)
    prophylaxisstatus = models.CharField(max_length=255, blank=True, null=True)
    dateofprophylaxis = models.DateTimeField(blank=True, null=True)
    visitedhealthfacility = models.CharField(max_length=255, blank=True, null=True)
    contactwithsourcerespiratorycase = models.CharField(max_length=255, blank=True, null=True)
    visitedanimalmarket = models.CharField(max_length=255, blank=True, null=True)
    camels = models.CharField(max_length=255, blank=True, null=True)
    snakes = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'epidata_history'


class EpidataburialHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    epidata_id = models.BigIntegerField()
    burialpersonname = models.CharField(max_length=512, blank=True, null=True)
    burialrelation = models.CharField(max_length=512, blank=True, null=True)
    burialdatefrom = models.DateTimeField(blank=True, null=True)
    burialdateto = models.DateTimeField(blank=True, null=True)
    burialaddress_id = models.BigIntegerField(blank=True, null=True)
    burialill = models.CharField(max_length=255, blank=True, null=True)
    burialtouching = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'epidataburial_history'


class EpidatagatheringHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    epidata_id = models.BigIntegerField()
    description = models.CharField(max_length=4096, blank=True, null=True)
    gatheringdate = models.DateTimeField(blank=True, null=True)
    gatheringaddress_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'epidatagathering_history'


class Epidatatravel(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    epidata = models.ForeignKey(Epidata, models.DO_NOTHING)
    traveltype = models.CharField(max_length=255, blank=True, null=True)
    traveldestination = models.CharField(max_length=512, blank=True, null=True)
    traveldatefrom = models.DateTimeField(blank=True, null=True)
    traveldateto = models.DateTimeField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'epidatatravel'


class EpidatatravelHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    epidata_id = models.BigIntegerField()
    traveltype = models.CharField(max_length=255, blank=True, null=True)
    traveldestination = models.CharField(max_length=512, blank=True, null=True)
    traveldatefrom = models.DateTimeField(blank=True, null=True)
    traveldateto = models.DateTimeField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'epidatatravel_history'


class EventsHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    eventstatus = models.CharField(max_length=255)
    eventdesc = models.CharField(max_length=4096, blank=True, null=True)
    eventdate = models.DateTimeField(blank=True, null=True)
    reportdatetime = models.DateTimeField()
    reportinguser_id = models.BigIntegerField()
    eventlocation_id = models.BigIntegerField(blank=True, null=True)
    typeofplace = models.CharField(max_length=255, blank=True, null=True)
    srcfirstname = models.CharField(max_length=512, blank=True, null=True)
    srclastname = models.CharField(max_length=512, blank=True, null=True)
    srctelno = models.CharField(max_length=512, blank=True, null=True)
    srcemail = models.CharField(max_length=512, blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    surveillanceofficer_id = models.BigIntegerField(blank=True, null=True)
    typeofplacetext = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    diseasedetails = models.CharField(max_length=512, blank=True, null=True)
    eventtitle = models.CharField(max_length=512, blank=True, null=True)
    eventinvestigationstatus = models.CharField(max_length=255, blank=True, null=True)
    eventinvestigationstartdate = models.DateTimeField(blank=True, null=True)
    eventinvestigationenddate = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'events_history'


class ExportconfigurationHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=512, blank=True, null=True)
    user_id = models.BigIntegerField(blank=True, null=True)
    exporttype = models.CharField(max_length=255, blank=True, null=True)
    propertiesstring = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'exportconfiguration_history'


class Facility(SormasModel):
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=255, blank=True, null=True)
    publicownership = models.BooleanField()
    type = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=36)
    region = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    community = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    city = models.CharField(max_length=512, blank=True, null=True)
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'facility'


class Featureconfiguration(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    featuretype = models.CharField(max_length=255, blank=True, null=True)
    region = models.ForeignKey('Region', models.DO_NOTHING, blank=True, null=True)
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    enddate = models.DateTimeField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    enabled = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'featureconfiguration'


class FeatureconfigurationHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    featuretype = models.CharField(max_length=255, blank=True, null=True)
    region_id = models.BigIntegerField(blank=True, null=True)
    district_id = models.BigIntegerField(blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    enddate = models.DateTimeField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    enabled = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'featureconfiguration_history'


class Healthconditions(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    tuberculosis = models.CharField(max_length=255, blank=True, null=True)
    asplenia = models.CharField(max_length=255, blank=True, null=True)
    hepatitis = models.CharField(max_length=255, blank=True, null=True)
    diabetes = models.CharField(max_length=255, blank=True, null=True)
    hiv = models.CharField(max_length=255, blank=True, null=True)
    hivart = models.CharField(max_length=255, blank=True, null=True)
    chronicliverdisease = models.CharField(max_length=255, blank=True, null=True)
    malignancychemotherapy = models.CharField(max_length=255, blank=True, null=True)
    chronicheartfailure = models.CharField(max_length=255, blank=True, null=True)
    chronicpulmonarydisease = models.CharField(max_length=255, blank=True, null=True)
    chronickidneydisease = models.CharField(max_length=255, blank=True, null=True)
    chronicneurologiccondition = models.CharField(max_length=255, blank=True, null=True)
    otherconditions = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    downsyndrome = models.CharField(max_length=255, blank=True, null=True)
    congenitalsyphilis = models.CharField(max_length=255, blank=True, null=True)
    immunodeficiencyotherthanhiv = models.CharField(max_length=255, blank=True, null=True)
    cardiovasculardiseaseincludinghypertension = models.CharField(max_length=255, blank=True, null=True)
    obesity = models.CharField(max_length=255, blank=True, null=True)
    currentsmoker = models.CharField(max_length=255, blank=True, null=True)
    formersmoker = models.CharField(max_length=255, blank=True, null=True)
    asthma = models.CharField(max_length=255, blank=True, null=True)
    sicklecelldisease = models.CharField(max_length=255, blank=True, null=True)
    immunodeficiencyincludinghiv = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'healthconditions'


class Clinicalcourse(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    sys_period = models.TextField()  # This field type is a guess.
    healthconditions = models.ForeignKey(Healthconditions, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'clinicalcourse'


class HealthconditionsHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    tuberculosis = models.CharField(max_length=255, blank=True, null=True)
    asplenia = models.CharField(max_length=255, blank=True, null=True)
    hepatitis = models.CharField(max_length=255, blank=True, null=True)
    diabetes = models.CharField(max_length=255, blank=True, null=True)
    hiv = models.CharField(max_length=255, blank=True, null=True)
    hivart = models.CharField(max_length=255, blank=True, null=True)
    chronicliverdisease = models.CharField(max_length=255, blank=True, null=True)
    malignancychemotherapy = models.CharField(max_length=255, blank=True, null=True)
    chronicheartfailure = models.CharField(max_length=255, blank=True, null=True)
    chronicpulmonarydisease = models.CharField(max_length=255, blank=True, null=True)
    chronickidneydisease = models.CharField(max_length=255, blank=True, null=True)
    chronicneurologiccondition = models.CharField(max_length=255, blank=True, null=True)
    otherconditions = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    downsyndrome = models.CharField(max_length=255, blank=True, null=True)
    congenitalsyphilis = models.CharField(max_length=255, blank=True, null=True)
    immunodeficiencyotherthanhiv = models.CharField(max_length=255, blank=True, null=True)
    cardiovasculardiseaseincludinghypertension = models.CharField(max_length=255, blank=True, null=True)
    obesity = models.CharField(max_length=255, blank=True, null=True)
    currentsmoker = models.CharField(max_length=255, blank=True, null=True)
    formersmoker = models.CharField(max_length=255, blank=True, null=True)
    asthma = models.CharField(max_length=255, blank=True, null=True)
    sicklecelldisease = models.CharField(max_length=255, blank=True, null=True)
    immunodeficiencyincludinghiv = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'healthconditions_history'


class Hospitalization(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    admissiondate = models.DateTimeField(blank=True, null=True)
    isolated = models.CharField(max_length=255, blank=True, null=True)
    isolationdate = models.DateTimeField(blank=True, null=True)
    hospitalizedpreviously = models.CharField(max_length=255, blank=True, null=True)
    dischargedate = models.DateTimeField(blank=True, null=True)
    changedateofembeddedlists = models.DateTimeField(blank=True, null=True)
    admittedtohealthfacility = models.CharField(max_length=255, blank=True, null=True)
    leftagainstadvice = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    intensivecareunit = models.CharField(max_length=255, blank=True, null=True)
    intensivecareunitstart = models.DateTimeField(blank=True, null=True)
    intensivecareunitend = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'hospitalization'


class HospitalizationHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    admissiondate = models.DateTimeField(blank=True, null=True)
    isolated = models.CharField(max_length=255, blank=True, null=True)
    isolationdate = models.DateTimeField(blank=True, null=True)
    hospitalizedpreviously = models.CharField(max_length=255, blank=True, null=True)
    dischargedate = models.DateTimeField(blank=True, null=True)
    changedateofembeddedlists = models.DateTimeField(blank=True, null=True)
    admittedtohealthfacility = models.CharField(max_length=255, blank=True, null=True)
    leftagainstadvice = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    intensivecareunit = models.CharField(max_length=255, blank=True, null=True)
    intensivecareunitstart = models.DateTimeField(blank=True, null=True)
    intensivecareunitend = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'hospitalization_history'


class Location(SormasModel):
    street = models.CharField(max_length=4096, blank=True, null=True)
    changedate = models.DateTimeField()
    city = models.CharField(max_length=512, blank=True, null=True)
    creationdate = models.DateTimeField()
    details = models.CharField(max_length=512, blank=True, null=True)
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=36)
    community = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    region = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    latlonaccuracy = models.FloatField(blank=True, null=True)
    areatype = models.CharField(max_length=255, blank=True, null=True)
    postalcode = models.CharField(max_length=512, blank=True, null=True)
    housenumber = models.CharField(max_length=255, blank=True, null=True)
    additionalinformation = models.CharField(max_length=255, blank=True, null=True)
    addresstype = models.CharField(max_length=255, blank=True, null=True)
    addresstypedetails = models.CharField(max_length=255, blank=True, null=True)
    facilitytype = models.CharField(max_length=255, blank=True, null=True)
    facility = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True)
    facilitydetails = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'location'


class Epidatagathering(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    epidata = models.ForeignKey(Epidata, models.DO_NOTHING)
    description = models.CharField(max_length=4096, blank=True, null=True)
    gatheringdate = models.DateTimeField(blank=True, null=True)
    gatheringaddress = models.ForeignKey(Location, models.DO_NOTHING, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'epidatagathering'


class Epidataburial(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    epidata = models.ForeignKey(Epidata, models.DO_NOTHING)
    burialpersonname = models.CharField(max_length=512, blank=True, null=True)
    burialrelation = models.CharField(max_length=512, blank=True, null=True)
    burialdatefrom = models.DateTimeField(blank=True, null=True)
    burialdateto = models.DateTimeField(blank=True, null=True)
    burialaddress = models.ForeignKey(Location, models.DO_NOTHING, blank=True, null=True)
    burialill = models.CharField(max_length=255, blank=True, null=True)
    burialtouching = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'epidataburial'


class LocationHistory(SormasModel):
    street = models.CharField(max_length=4096, blank=True, null=True)
    changedate = models.DateTimeField()
    city = models.CharField(max_length=512, blank=True, null=True)
    creationdate = models.DateTimeField()
    details = models.CharField(max_length=512, blank=True, null=True)
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    uuid = models.CharField(max_length=36)
    community_id = models.BigIntegerField(blank=True, null=True)
    district_id = models.BigIntegerField(blank=True, null=True)
    region_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    latlonaccuracy = models.FloatField(blank=True, null=True)
    areatype = models.CharField(max_length=255, blank=True, null=True)
    postalcode = models.CharField(max_length=512, blank=True, null=True)
    housenumber = models.CharField(max_length=255, blank=True, null=True)
    additionalinformation = models.CharField(max_length=255, blank=True, null=True)
    addresstype = models.CharField(max_length=255, blank=True, null=True)
    addresstypedetails = models.CharField(max_length=255, blank=True, null=True)
    person_id = models.BigIntegerField(blank=True, null=True)
    facilitytype = models.CharField(max_length=255, blank=True, null=True)
    facility_id = models.BigIntegerField(blank=True, null=True)
    facilitydetails = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'location_history'


class Maternalhistory(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    childrennumber = models.IntegerField(blank=True, null=True)
    ageatbirth = models.IntegerField(blank=True, null=True)
    conjunctivitis = models.CharField(max_length=255, blank=True, null=True)
    conjunctivitisonset = models.DateTimeField(blank=True, null=True)
    conjunctivitismonth = models.IntegerField(blank=True, null=True)
    maculopapularrash = models.CharField(max_length=255, blank=True, null=True)
    maculopapularrashonset = models.DateTimeField(blank=True, null=True)
    maculopapularrashmonth = models.IntegerField(blank=True, null=True)
    swollenlymphs = models.CharField(max_length=255, blank=True, null=True)
    swollenlymphsonset = models.DateTimeField(blank=True, null=True)
    swollenlymphsmonth = models.IntegerField(blank=True, null=True)
    arthralgiaarthritis = models.CharField(max_length=255, blank=True, null=True)
    arthralgiaarthritisonset = models.DateTimeField(blank=True, null=True)
    arthralgiaarthritismonth = models.IntegerField(blank=True, null=True)
    othercomplications = models.CharField(max_length=255, blank=True, null=True)
    othercomplicationsonset = models.DateTimeField(blank=True, null=True)
    othercomplicationsmonth = models.IntegerField(blank=True, null=True)
    othercomplicationsdetails = models.CharField(max_length=512, blank=True, null=True)
    rubella = models.CharField(max_length=255, blank=True, null=True)
    rubellaonset = models.DateTimeField(blank=True, null=True)
    rashexposure = models.CharField(max_length=255, blank=True, null=True)
    rashexposuredate = models.DateTimeField(blank=True, null=True)
    rashexposuremonth = models.IntegerField(blank=True, null=True)
    rashexposureregion = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    rashexposuredistrict = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    rashexposurecommunity = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'maternalhistory'


class MaternalhistoryHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    childrennumber = models.IntegerField(blank=True, null=True)
    ageatbirth = models.IntegerField(blank=True, null=True)
    conjunctivitis = models.CharField(max_length=255, blank=True, null=True)
    conjunctivitisonset = models.DateTimeField(blank=True, null=True)
    conjunctivitismonth = models.IntegerField(blank=True, null=True)
    maculopapularrash = models.CharField(max_length=255, blank=True, null=True)
    maculopapularrashonset = models.DateTimeField(blank=True, null=True)
    maculopapularrashmonth = models.IntegerField(blank=True, null=True)
    swollenlymphs = models.CharField(max_length=255, blank=True, null=True)
    swollenlymphsonset = models.DateTimeField(blank=True, null=True)
    swollenlymphsmonth = models.IntegerField(blank=True, null=True)
    arthralgiaarthritis = models.CharField(max_length=255, blank=True, null=True)
    arthralgiaarthritisonset = models.DateTimeField(blank=True, null=True)
    arthralgiaarthritismonth = models.IntegerField(blank=True, null=True)
    othercomplications = models.CharField(max_length=255, blank=True, null=True)
    othercomplicationsonset = models.DateTimeField(blank=True, null=True)
    othercomplicationsmonth = models.IntegerField(blank=True, null=True)
    othercomplicationsdetails = models.CharField(max_length=512, blank=True, null=True)
    rubella = models.CharField(max_length=255, blank=True, null=True)
    rubellaonset = models.DateTimeField(blank=True, null=True)
    rashexposure = models.CharField(max_length=255, blank=True, null=True)
    rashexposuredate = models.DateTimeField(blank=True, null=True)
    rashexposuremonth = models.IntegerField(blank=True, null=True)
    rashexposureregion_id = models.BigIntegerField(blank=True, null=True)
    rashexposuredistrict_id = models.BigIntegerField(blank=True, null=True)
    rashexposurecommunity_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'maternalhistory_history'


class OutbreakHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    district_id = models.BigIntegerField()
    disease = models.CharField(max_length=255)
    reportdate = models.DateTimeField()
    reportinguser_id = models.BigIntegerField()
    sys_period = models.TextField()  # This field type is a guess.
    startdate = models.DateTimeField(blank=True, null=True)
    enddate = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'outbreak_history'

    class Meta:
        managed = False
        db_table = 'pathogentest'


class PathogentestHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    sample_id = models.BigIntegerField()
    testtype = models.CharField(max_length=255)
    testtypetext = models.CharField(max_length=512, blank=True, null=True)
    testdatetime = models.DateTimeField()
    lab_id = models.BigIntegerField(blank=True, null=True)
    labuser_id = models.BigIntegerField(blank=True, null=True)
    testresult = models.CharField(max_length=255)
    testresulttext = models.CharField(max_length=4096, blank=True, null=True)
    testresultverified = models.BooleanField()
    sys_period = models.TextField()  # This field type is a guess.
    fourfoldincreaseantibodytiter = models.BooleanField(blank=True, null=True)
    labdetails = models.CharField(max_length=512, blank=True, null=True)
    testeddisease = models.CharField(max_length=255, blank=True, null=True)
    testeddiseasedetails = models.CharField(max_length=512, blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    serotype = models.CharField(max_length=512, blank=True, null=True)
    cqvalue = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'pathogentest_history'


class Person(SormasModel):
    approximateage = models.IntegerField(blank=True, null=True)
    burialconductor = models.CharField(max_length=255, blank=True, null=True)
    burialdate = models.DateField(blank=True, null=True)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    deathdate = models.DateField(blank=True, null=True)
    firstname = models.CharField(max_length=512)
    lastname = models.CharField(max_length=512)
    occupationdetails = models.CharField(max_length=255, blank=True, null=True)
    occupationtype = models.CharField(max_length=255, blank=True, null=True)
    phone = models.CharField(max_length=255, blank=True, null=True)
    presentcondition = models.IntegerField(blank=True, null=True)
    sex = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=36)
    address = models.ForeignKey(Location, models.DO_NOTHING, blank=True, null=True)
    phoneowner = models.CharField(max_length=255, blank=True, null=True)
    birthdate_dd = models.IntegerField(blank=True, null=True)
    birthdate_mm = models.IntegerField(blank=True, null=True)
    birthdate_yyyy = models.IntegerField(blank=True, null=True)
    nickname = models.CharField(max_length=512, blank=True, null=True)
    mothersmaidenname = models.CharField(max_length=255, blank=True, null=True)
    deathplacetype = models.CharField(max_length=255, blank=True, null=True)
    deathplacedescription = models.CharField(max_length=512, blank=True, null=True)
    burialplacedescription = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    causeofdeath = models.CharField(max_length=255, blank=True, null=True)
    causeofdeathdetails = models.CharField(max_length=512, blank=True, null=True)
    causeofdeathdisease = models.CharField(max_length=255, blank=True, null=True)
    educationtype = models.CharField(max_length=255, blank=True, null=True)
    educationdetails = models.CharField(max_length=255, blank=True, null=True)
    approximateagereferencedate = models.DateField(blank=True, null=True)
    approximateagetype = models.CharField(max_length=255, blank=True, null=True)
    mothersname = models.CharField(max_length=512, blank=True, null=True)
    fathersname = models.CharField(max_length=512, blank=True, null=True)
    placeofbirthregion = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    placeofbirthdistrict = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    placeofbirthcommunity = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    placeofbirthfacility = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True)
    placeofbirthfacilitydetails = models.CharField(max_length=512, blank=True, null=True)
    gestationageatbirth = models.IntegerField(blank=True, null=True)
    birthweight = models.IntegerField(blank=True, null=True)
    generalpractitionerdetails = models.CharField(max_length=512, blank=True, null=True)
    emailaddress = models.CharField(max_length=255, blank=True, null=True)
    passportnumber = models.CharField(max_length=255, blank=True, null=True)
    nationalhealthid = models.CharField(max_length=255, blank=True, null=True)
    placeofbirthfacilitytype = models.CharField(max_length=255, blank=True, null=True)
    changedateofembeddedlists = models.DateTimeField(blank=True, null=True)
    symptomjournalstatus = models.CharField(max_length=255, blank=True, null=True)
    hascovidapp = models.BooleanField(blank=True, null=True)
    covidcodedelivered = models.BooleanField(blank=True, null=True)
    externalid = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'person'


class PersonHistory(SormasModel):
    approximateage = models.IntegerField(blank=True, null=True)
    burialconductor = models.CharField(max_length=255, blank=True, null=True)
    burialdate = models.DateField(blank=True, null=True)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    deathdate = models.DateField(blank=True, null=True)
    firstname = models.CharField(max_length=512)
    lastname = models.CharField(max_length=512)
    occupationdetails = models.CharField(max_length=255, blank=True, null=True)
    occupationtype = models.CharField(max_length=255, blank=True, null=True)
    phone = models.CharField(max_length=255, blank=True, null=True)
    presentcondition = models.IntegerField(blank=True, null=True)
    sex = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(max_length=36)
    address_id = models.BigIntegerField(blank=True, null=True)
    occupationfacility_id = models.BigIntegerField(blank=True, null=True)
    phoneowner = models.CharField(max_length=255, blank=True, null=True)
    birthdate_dd = models.IntegerField(blank=True, null=True)
    birthdate_mm = models.IntegerField(blank=True, null=True)
    birthdate_yyyy = models.IntegerField(blank=True, null=True)
    nickname = models.CharField(max_length=512, blank=True, null=True)
    mothersmaidenname = models.CharField(max_length=255, blank=True, null=True)
    deathplacetype = models.CharField(max_length=255, blank=True, null=True)
    deathplacedescription = models.CharField(max_length=512, blank=True, null=True)
    burialplacedescription = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    causeofdeath = models.CharField(max_length=255, blank=True, null=True)
    causeofdeathdetails = models.CharField(max_length=512, blank=True, null=True)
    causeofdeathdisease = models.CharField(max_length=255, blank=True, null=True)
    occupationfacilitydetails = models.CharField(max_length=512, blank=True, null=True)
    occupationregion_id = models.BigIntegerField(blank=True, null=True)
    occupationdistrict_id = models.BigIntegerField(blank=True, null=True)
    occupationcommunity_id = models.BigIntegerField(blank=True, null=True)
    educationtype = models.CharField(max_length=255, blank=True, null=True)
    educationdetails = models.CharField(max_length=255, blank=True, null=True)
    approximateagereferencedate = models.DateField(blank=True, null=True)
    approximateagetype = models.CharField(max_length=255, blank=True, null=True)
    mothersname = models.CharField(max_length=512, blank=True, null=True)
    fathersname = models.CharField(max_length=512, blank=True, null=True)
    placeofbirthregion_id = models.BigIntegerField(blank=True, null=True)
    placeofbirthdistrict_id = models.BigIntegerField(blank=True, null=True)
    placeofbirthcommunity_id = models.BigIntegerField(blank=True, null=True)
    placeofbirthfacility_id = models.BigIntegerField(blank=True, null=True)
    placeofbirthfacilitydetails = models.CharField(max_length=512, blank=True, null=True)
    gestationageatbirth = models.IntegerField(blank=True, null=True)
    birthweight = models.IntegerField(blank=True, null=True)
    generalpractitionerdetails = models.CharField(max_length=512, blank=True, null=True)
    emailaddress = models.CharField(max_length=255, blank=True, null=True)
    passportnumber = models.CharField(max_length=255, blank=True, null=True)
    nationalhealthid = models.CharField(max_length=255, blank=True, null=True)
    occupationfacilitytype = models.CharField(max_length=255, blank=True, null=True)
    placeofbirthfacilitytype = models.CharField(max_length=255, blank=True, null=True)
    symptomjournalstatus = models.CharField(max_length=255, blank=True, null=True)
    hascovidapp = models.BooleanField(blank=True, null=True)
    covidcodedelivered = models.BooleanField(blank=True, null=True)
    externalid = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'person_history'


class PersonLocations(SormasModel):
    person = models.ForeignKey(Person, models.DO_NOTHING)
    location = models.ForeignKey(Location, models.DO_NOTHING)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'person_locations'
        unique_together = (('person', 'location'),)


class PersonLocationsHistory(SormasModel):
    person_id = models.BigIntegerField()
    location_id = models.BigIntegerField()
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'person_locations_history'


class Pointofentry(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    pointofentrytype = models.CharField(max_length=255, blank=True, null=True)
    name = models.CharField(max_length=512, blank=True, null=True)
    region = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    active = models.BooleanField(blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'pointofentry'


class Populationdata(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    region = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    sex = models.CharField(max_length=255, blank=True, null=True)
    agegroup = models.CharField(max_length=255, blank=True, null=True)
    population = models.IntegerField(blank=True, null=True)
    collectiondate = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'populationdata'


class Porthealthinfo(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    airlinename = models.CharField(max_length=512, blank=True, null=True)
    flightnumber = models.CharField(max_length=512, blank=True, null=True)
    departuredatetime = models.DateTimeField(blank=True, null=True)
    arrivaldatetime = models.DateTimeField(blank=True, null=True)
    freeseating = models.CharField(max_length=255, blank=True, null=True)
    seatnumber = models.CharField(max_length=512, blank=True, null=True)
    departureairport = models.CharField(max_length=512, blank=True, null=True)
    numberoftransitstops = models.IntegerField(blank=True, null=True)
    transitstopdetails1 = models.CharField(max_length=512, blank=True, null=True)
    transitstopdetails2 = models.CharField(max_length=512, blank=True, null=True)
    transitstopdetails3 = models.CharField(max_length=512, blank=True, null=True)
    transitstopdetails4 = models.CharField(max_length=512, blank=True, null=True)
    transitstopdetails5 = models.CharField(max_length=512, blank=True, null=True)
    vesselname = models.CharField(max_length=512, blank=True, null=True)
    vesseldetails = models.CharField(max_length=512, blank=True, null=True)
    portofdeparture = models.CharField(max_length=512, blank=True, null=True)
    lastportofcall = models.CharField(max_length=512, blank=True, null=True)
    conveyancetype = models.CharField(max_length=255, blank=True, null=True)
    conveyancetypedetails = models.CharField(max_length=512, blank=True, null=True)
    departurelocation = models.CharField(max_length=512, blank=True, null=True)
    finaldestination = models.CharField(max_length=512, blank=True, null=True)
    details = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'porthealthinfo'


class PorthealthinfoHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    airlinename = models.CharField(max_length=512, blank=True, null=True)
    flightnumber = models.CharField(max_length=512, blank=True, null=True)
    departuredatetime = models.DateTimeField(blank=True, null=True)
    arrivaldatetime = models.DateTimeField(blank=True, null=True)
    freeseating = models.CharField(max_length=255, blank=True, null=True)
    seatnumber = models.CharField(max_length=512, blank=True, null=True)
    departureairport = models.CharField(max_length=512, blank=True, null=True)
    numberoftransitstops = models.IntegerField(blank=True, null=True)
    transitstopdetails1 = models.CharField(max_length=512, blank=True, null=True)
    transitstopdetails2 = models.CharField(max_length=512, blank=True, null=True)
    transitstopdetails3 = models.CharField(max_length=512, blank=True, null=True)
    transitstopdetails4 = models.CharField(max_length=512, blank=True, null=True)
    transitstopdetails5 = models.CharField(max_length=512, blank=True, null=True)
    vesselname = models.CharField(max_length=512, blank=True, null=True)
    vesseldetails = models.CharField(max_length=512, blank=True, null=True)
    portofdeparture = models.CharField(max_length=512, blank=True, null=True)
    lastportofcall = models.CharField(max_length=512, blank=True, null=True)
    conveyancetype = models.CharField(max_length=255, blank=True, null=True)
    conveyancetypedetails = models.CharField(max_length=512, blank=True, null=True)
    departurelocation = models.CharField(max_length=512, blank=True, null=True)
    finaldestination = models.CharField(max_length=512, blank=True, null=True)
    details = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'porthealthinfo_history'


class PrescriptionHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    therapy_id = models.BigIntegerField()
    prescriptiondate = models.DateTimeField()
    prescriptionstart = models.DateTimeField(blank=True, null=True)
    prescriptionend = models.DateTimeField(blank=True, null=True)
    prescribingclinician = models.CharField(max_length=512, blank=True, null=True)
    prescriptiontype = models.CharField(max_length=255)
    prescriptiondetails = models.CharField(max_length=512, blank=True, null=True)
    frequency = models.CharField(max_length=512, blank=True, null=True)
    dose = models.CharField(max_length=512, blank=True, null=True)
    route = models.CharField(max_length=255, blank=True, null=True)
    routedetails = models.CharField(max_length=512, blank=True, null=True)
    additionalnotes = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    typeofdrug = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'prescription_history'


class Previoushospitalization(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    admissiondate = models.DateTimeField(blank=True, null=True)
    dischargedate = models.DateTimeField(blank=True, null=True)
    healthfacility = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True)
    isolated = models.CharField(max_length=255, blank=True, null=True)
    hospitalization = models.ForeignKey(Hospitalization, models.DO_NOTHING)
    description = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    region = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    community = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    healthfacilitydetails = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'previoushospitalization'


class PrevioushospitalizationHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    admissiondate = models.DateTimeField(blank=True, null=True)
    dischargedate = models.DateTimeField(blank=True, null=True)
    healthfacility_id = models.BigIntegerField(blank=True, null=True)
    isolated = models.CharField(max_length=255, blank=True, null=True)
    hospitalization_id = models.BigIntegerField()
    description = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    region_id = models.BigIntegerField(blank=True, null=True)
    district_id = models.BigIntegerField(blank=True, null=True)
    community_id = models.BigIntegerField(blank=True, null=True)
    healthfacilitydetails = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'previoushospitalization_history'


class SamplesHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    associatedcase_id = models.BigIntegerField(blank=True, null=True)
    samplecode = models.CharField(max_length=512, blank=True, null=True)
    sampledatetime = models.DateTimeField()
    reportdatetime = models.DateTimeField()
    reportinguser_id = models.BigIntegerField()
    samplematerial = models.CharField(max_length=255)
    samplematerialtext = models.CharField(max_length=512, blank=True, null=True)
    lab_id = models.BigIntegerField(blank=True, null=True)
    otherlab_id = models.BigIntegerField(blank=True, null=True)
    shipmentdate = models.DateTimeField(blank=True, null=True)
    shipmentdetails = models.CharField(max_length=512, blank=True, null=True)
    receiveddate = models.DateTimeField(blank=True, null=True)
    notestpossiblereason = models.CharField(max_length=512, blank=True, null=True)
    comment = models.CharField(max_length=4096, blank=True, null=True)
    specimencondition = models.CharField(max_length=255, blank=True, null=True)
    labsampleid = models.CharField(max_length=512, blank=True, null=True)
    samplesource = models.CharField(max_length=255, blank=True, null=True)
    suggestedtypeoftest = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    labdetails = models.CharField(max_length=512, blank=True, null=True)
    pathogentestingrequested = models.BooleanField(blank=True, null=True)
    additionaltestingrequested = models.BooleanField(blank=True, null=True)
    requestedpathogentestsstring = models.CharField(max_length=512, blank=True, null=True)
    requestedadditionaltestsstring = models.CharField(max_length=512, blank=True, null=True)
    pathogentestresult = models.CharField(max_length=255, blank=True, null=True)
    requestedotherpathogentests = models.CharField(max_length=512, blank=True, null=True)
    requestedotheradditionaltests = models.CharField(max_length=512, blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    pathogentestresultchangedate = models.DateTimeField(blank=True, null=True)
    samplepurpose = models.CharField(max_length=255)
    fieldsampleid = models.CharField(max_length=512, blank=True, null=True)
    associatedcontact_id = models.BigIntegerField(blank=True, null=True)
    associatedeventparticipant_id = models.BigIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'samples_history'


class Sormastosormasorigininfo(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    creationdate = models.DateTimeField()
    changedate = models.DateTimeField()
    organizationid = models.CharField(max_length=512, blank=True, null=True)
    sendername = models.CharField(max_length=512, blank=True, null=True)
    senderemail = models.CharField(max_length=512, blank=True, null=True)
    senderphonenumber = models.CharField(max_length=512, blank=True, null=True)
    ownershiphandedover = models.BooleanField()
    comment = models.CharField(max_length=4096, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sormastosormasorigininfo'


class Symptoms(SormasModel):
    abdominalpain = models.CharField(max_length=255, blank=True, null=True)
    anorexiaappetiteloss = models.CharField(max_length=255, blank=True, null=True)
    bleedingvagina = models.CharField(max_length=255, blank=True, null=True)
    changedate = models.DateTimeField()
    chestpain = models.CharField(max_length=255, blank=True, null=True)
    confuseddisoriented = models.CharField(max_length=255, blank=True, null=True)
    conjunctivitis = models.CharField(max_length=255, blank=True, null=True)
    cough = models.CharField(max_length=255, blank=True, null=True)
    creationdate = models.DateTimeField()
    diarrhea = models.CharField(max_length=255, blank=True, null=True)
    difficultybreathing = models.CharField(max_length=255, blank=True, null=True)
    digestedbloodvomit = models.CharField(max_length=255, blank=True, null=True)
    eyepainlightsensitive = models.CharField(max_length=255, blank=True, null=True)
    fever = models.CharField(max_length=255, blank=True, null=True)
    gumsbleeding = models.CharField(max_length=255, blank=True, null=True)
    headache = models.CharField(max_length=255, blank=True, null=True)
    hemoptysis = models.CharField(max_length=255, blank=True, null=True)
    hiccups = models.CharField(max_length=255, blank=True, null=True)
    injectionsitebleeding = models.CharField(max_length=255, blank=True, null=True)
    jointpain = models.CharField(max_length=255, blank=True, null=True)
    musclepain = models.CharField(max_length=255, blank=True, null=True)
    otherhemorrhagicsymptoms = models.CharField(max_length=255, blank=True, null=True)
    otherhemorrhagicsymptomstext = models.CharField(max_length=512, blank=True, null=True)
    othernonhemorrhagicsymptoms = models.CharField(max_length=255, blank=True, null=True)
    othernonhemorrhagicsymptomstext = models.CharField(max_length=512, blank=True, null=True)
    skinrash = models.CharField(max_length=255, blank=True, null=True)
    sorethroat = models.CharField(max_length=255, blank=True, null=True)
    onsetdate = models.DateTimeField(blank=True, null=True)
    temperature = models.FloatField(blank=True, null=True)
    temperaturesource = models.CharField(max_length=255, blank=True, null=True)
    unexplainedbleeding = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=36)
    vomiting = models.CharField(max_length=255, blank=True, null=True)
    dehydration = models.CharField(max_length=255, blank=True, null=True)
    fatigueweakness = models.CharField(max_length=255, blank=True, null=True)
    kopliksspots = models.CharField(max_length=255, blank=True, null=True)
    nausea = models.CharField(max_length=255, blank=True, null=True)
    neckstiffness = models.CharField(max_length=255, blank=True, null=True)
    onsetsymptom = models.CharField(max_length=512, blank=True, null=True)
    otitismedia = models.CharField(max_length=255, blank=True, null=True)
    refusalfeedordrink = models.CharField(max_length=255, blank=True, null=True)
    runnynose = models.CharField(max_length=255, blank=True, null=True)
    seizures = models.CharField(max_length=255, blank=True, null=True)
    symptomatic = models.BooleanField(blank=True, null=True)
    bloodinstool = models.CharField(max_length=255, blank=True, null=True)
    nosebleeding = models.CharField(max_length=255, blank=True, null=True)
    bloodyblackstool = models.CharField(max_length=255, blank=True, null=True)
    redbloodvomit = models.CharField(max_length=255, blank=True, null=True)
    coughingblood = models.CharField(max_length=255, blank=True, null=True)
    skinbruising = models.CharField(max_length=255, blank=True, null=True)
    bloodurine = models.CharField(max_length=255, blank=True, null=True)
    alteredconsciousness = models.CharField(max_length=255, blank=True, null=True)
    throbocytopenia = models.CharField(max_length=255, blank=True, null=True)
    hearingloss = models.CharField(max_length=255, blank=True, null=True)
    shock = models.CharField(max_length=255, blank=True, null=True)
    symptomscomments = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    backache = models.CharField(max_length=255, blank=True, null=True)
    eyesbleeding = models.CharField(max_length=255, blank=True, null=True)
    jaundice = models.CharField(max_length=255, blank=True, null=True)
    darkurine = models.CharField(max_length=255, blank=True, null=True)
    stomachbleeding = models.CharField(max_length=255, blank=True, null=True)
    rapidbreathing = models.CharField(max_length=255, blank=True, null=True)
    swollenglands = models.CharField(max_length=255, blank=True, null=True)
    lesions = models.CharField(max_length=255, blank=True, null=True)
    lesionssamestate = models.CharField(max_length=255, blank=True, null=True)
    lesionssamesize = models.CharField(max_length=255, blank=True, null=True)
    lesionsdeepprofound = models.CharField(max_length=255, blank=True, null=True)
    lesionsface = models.BooleanField(blank=True, null=True)
    lesionslegs = models.BooleanField(blank=True, null=True)
    lesionssolesfeet = models.BooleanField(blank=True, null=True)
    lesionspalmshands = models.BooleanField(blank=True, null=True)
    lesionsthorax = models.BooleanField(blank=True, null=True)
    lesionsarms = models.BooleanField(blank=True, null=True)
    lesionsgenitals = models.BooleanField(blank=True, null=True)
    lesionsalloverbody = models.BooleanField(blank=True, null=True)
    lesionsresembleimg1 = models.CharField(max_length=255, blank=True, null=True)
    lesionsresembleimg2 = models.CharField(max_length=255, blank=True, null=True)
    lesionsresembleimg3 = models.CharField(max_length=255, blank=True, null=True)
    lesionsresembleimg4 = models.CharField(max_length=255, blank=True, null=True)
    lymphadenopathyinguinal = models.CharField(max_length=255, blank=True, null=True)
    lymphadenopathyaxillary = models.CharField(max_length=255, blank=True, null=True)
    lymphadenopathycervical = models.CharField(max_length=255, blank=True, null=True)
    chillssweats = models.CharField(max_length=255, blank=True, null=True)
    lesionsthatitch = models.CharField(max_length=255, blank=True, null=True)
    bedridden = models.CharField(max_length=255, blank=True, null=True)
    oralulcers = models.CharField(max_length=255, blank=True, null=True)
    patientilllocation = models.CharField(max_length=512, blank=True, null=True)
    painfullymphadenitis = models.CharField(max_length=255, blank=True, null=True)
    buboesgroinarmpitneck = models.CharField(max_length=255, blank=True, null=True)
    blackeningdeathoftissue = models.CharField(max_length=255, blank=True, null=True)
    bulgingfontanelle = models.CharField(max_length=255, blank=True, null=True)
    lesionsonsetdate = models.DateTimeField(blank=True, null=True)
    meningealsigns = models.CharField(max_length=255, blank=True, null=True)
    bloodpressuresystolic = models.IntegerField(blank=True, null=True)
    bloodpressurediastolic = models.IntegerField(blank=True, null=True)
    heartrate = models.IntegerField(blank=True, null=True)
    pharyngealerythema = models.CharField(max_length=255, blank=True, null=True)
    pharyngealexudate = models.CharField(max_length=255, blank=True, null=True)
    oedemafaceneck = models.CharField(max_length=255, blank=True, null=True)
    oedemalowerextremity = models.CharField(max_length=255, blank=True, null=True)
    lossskinturgor = models.CharField(max_length=255, blank=True, null=True)
    palpableliver = models.CharField(max_length=255, blank=True, null=True)
    palpablespleen = models.CharField(max_length=255, blank=True, null=True)
    malaise = models.CharField(max_length=255, blank=True, null=True)
    sunkeneyesfontanelle = models.CharField(max_length=255, blank=True, null=True)
    sidepain = models.CharField(max_length=255, blank=True, null=True)
    fluidinlungcavity = models.CharField(max_length=255, blank=True, null=True)
    tremor = models.CharField(max_length=255, blank=True, null=True)
    hemorrhagicsyndrome = models.CharField(max_length=255, blank=True, null=True)
    hyperglycemia = models.CharField(max_length=255, blank=True, null=True)
    hypoglycemia = models.CharField(max_length=255, blank=True, null=True)
    sepsis = models.CharField(max_length=255, blank=True, null=True)
    midupperarmcircumference = models.IntegerField(blank=True, null=True)
    respiratoryrate = models.IntegerField(blank=True, null=True)
    weight = models.IntegerField(blank=True, null=True)
    height = models.IntegerField(blank=True, null=True)
    glasgowcomascale = models.IntegerField(blank=True, null=True)
    bilateralcataracts = models.CharField(max_length=255, blank=True, null=True)
    unilateralcataracts = models.CharField(max_length=255, blank=True, null=True)
    congenitalglaucoma = models.CharField(max_length=255, blank=True, null=True)
    pigmentaryretinopathy = models.CharField(max_length=255, blank=True, null=True)
    purpuricrash = models.CharField(max_length=255, blank=True, null=True)
    microcephaly = models.CharField(max_length=255, blank=True, null=True)
    developmentaldelay = models.CharField(max_length=255, blank=True, null=True)
    splenomegaly = models.CharField(max_length=255, blank=True, null=True)
    meningoencephalitis = models.CharField(max_length=255, blank=True, null=True)
    radiolucentbonedisease = models.CharField(max_length=255, blank=True, null=True)
    congenitalheartdisease = models.CharField(max_length=255, blank=True, null=True)
    congenitalheartdiseasetype = models.CharField(max_length=255, blank=True, null=True)
    congenitalheartdiseasedetails = models.CharField(max_length=512, blank=True, null=True)
    jaundicewithin24hoursofbirth = models.CharField(max_length=255, blank=True, null=True)
    hydrophobia = models.CharField(max_length=255, blank=True, null=True)
    opisthotonus = models.CharField(max_length=255, blank=True, null=True)
    anxietystates = models.CharField(max_length=255, blank=True, null=True)
    delirium = models.CharField(max_length=255, blank=True, null=True)
    uproariousness = models.CharField(max_length=255, blank=True, null=True)
    paresthesiaaroundwound = models.CharField(max_length=255, blank=True, null=True)
    excesssalivation = models.CharField(max_length=255, blank=True, null=True)
    insomnia = models.CharField(max_length=255, blank=True, null=True)
    paralysis = models.CharField(max_length=255, blank=True, null=True)
    excitation = models.CharField(max_length=255, blank=True, null=True)
    dysphagia = models.CharField(max_length=255, blank=True, null=True)
    aerophobia = models.CharField(max_length=255, blank=True, null=True)
    hyperactivity = models.CharField(max_length=255, blank=True, null=True)
    paresis = models.CharField(max_length=255, blank=True, null=True)
    agitation = models.CharField(max_length=255, blank=True, null=True)
    ascendingflaccidparalysis = models.CharField(max_length=255, blank=True, null=True)
    erraticbehaviour = models.CharField(max_length=255, blank=True, null=True)
    coma = models.CharField(max_length=255, blank=True, null=True)
    convulsion = models.CharField(max_length=255, blank=True, null=True)
    fluidinlungcavityauscultation = models.CharField(max_length=255, blank=True, null=True)
    fluidinlungcavityxray = models.CharField(max_length=255, blank=True, null=True)
    abnormallungxrayfindings = models.CharField(max_length=255, blank=True, null=True)
    conjunctivalinjection = models.CharField(max_length=255, blank=True, null=True)
    acuterespiratorydistresssyndrome = models.CharField(max_length=255, blank=True, null=True)
    pneumoniaclinicalorradiologic = models.CharField(max_length=255, blank=True, null=True)
    lossoftaste = models.CharField(max_length=255, blank=True, null=True)
    lossofsmell = models.CharField(max_length=255, blank=True, null=True)
    coughwithsputum = models.CharField(max_length=255, blank=True, null=True)
    coughwithheamoptysis = models.CharField(max_length=255, blank=True, null=True)
    lymphadenopathy = models.CharField(max_length=255, blank=True, null=True)
    wheezing = models.CharField(max_length=255, blank=True, null=True)
    skinulcers = models.CharField(max_length=255, blank=True, null=True)
    inabilitytowalk = models.CharField(max_length=255, blank=True, null=True)
    indrawingofchestwall = models.CharField(max_length=255, blank=True, null=True)
    othercomplications = models.CharField(max_length=255, blank=True, null=True)
    othercomplicationstext = models.CharField(max_length=512, blank=True, null=True)
    respiratorydiseaseventilation = models.CharField(max_length=255, blank=True, null=True)
    feelingill = models.CharField(max_length=255, blank=True, null=True)
    fastheartrate = models.CharField(max_length=255, blank=True, null=True)
    oxygensaturationlower94 = models.CharField(max_length=255, blank=True, null=True)
    feverishfeeling = models.CharField(max_length=255, blank=True, null=True)
    weakness = models.CharField(max_length=255, blank=True, null=True)
    fatigue = models.CharField(max_length=255, blank=True, null=True)
    coughwithoutsputum = models.CharField(max_length=255, blank=True, null=True)
    breathlessness = models.CharField(max_length=255, blank=True, null=True)
    chestpressure = models.CharField(max_length=255, blank=True, null=True)
    bluelips = models.CharField(max_length=255, blank=True, null=True)
    bloodcirculationproblems = models.CharField(max_length=255, blank=True, null=True)
    palpitations = models.CharField(max_length=255, blank=True, null=True)
    dizzinessstandingup = models.CharField(max_length=255, blank=True, null=True)
    highorlowbloodpressure = models.CharField(max_length=255, blank=True, null=True)
    urinaryretention = models.CharField(max_length=255, blank=True, null=True)
    shivering = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'symptoms'


class SymptomsHistory(SormasModel):
    abdominalpain = models.CharField(max_length=255, blank=True, null=True)
    anorexiaappetiteloss = models.CharField(max_length=255, blank=True, null=True)
    bleedingvagina = models.CharField(max_length=255, blank=True, null=True)
    changedate = models.DateTimeField()
    chestpain = models.CharField(max_length=255, blank=True, null=True)
    confuseddisoriented = models.CharField(max_length=255, blank=True, null=True)
    conjunctivitis = models.CharField(max_length=255, blank=True, null=True)
    cough = models.CharField(max_length=255, blank=True, null=True)
    creationdate = models.DateTimeField()
    diarrhea = models.CharField(max_length=255, blank=True, null=True)
    difficultybreathing = models.CharField(max_length=255, blank=True, null=True)
    digestedbloodvomit = models.CharField(max_length=255, blank=True, null=True)
    eyepainlightsensitive = models.CharField(max_length=255, blank=True, null=True)
    fever = models.CharField(max_length=255, blank=True, null=True)
    gumsbleeding = models.CharField(max_length=255, blank=True, null=True)
    headache = models.CharField(max_length=255, blank=True, null=True)
    hemoptysis = models.CharField(max_length=255, blank=True, null=True)
    hiccups = models.CharField(max_length=255, blank=True, null=True)
    injectionsitebleeding = models.CharField(max_length=255, blank=True, null=True)
    jointpain = models.CharField(max_length=255, blank=True, null=True)
    musclepain = models.CharField(max_length=255, blank=True, null=True)
    otherhemorrhagicsymptoms = models.CharField(max_length=255, blank=True, null=True)
    otherhemorrhagicsymptomstext = models.CharField(max_length=512, blank=True, null=True)
    othernonhemorrhagicsymptoms = models.CharField(max_length=255, blank=True, null=True)
    othernonhemorrhagicsymptomstext = models.CharField(max_length=512, blank=True, null=True)
    skinrash = models.CharField(max_length=255, blank=True, null=True)
    sorethroat = models.CharField(max_length=255, blank=True, null=True)
    onsetdate = models.DateTimeField(blank=True, null=True)
    temperature = models.FloatField(blank=True, null=True)
    temperaturesource = models.CharField(max_length=255, blank=True, null=True)
    unexplainedbleeding = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(max_length=36)
    vomiting = models.CharField(max_length=255, blank=True, null=True)
    dehydration = models.CharField(max_length=255, blank=True, null=True)
    fatigueweakness = models.CharField(max_length=255, blank=True, null=True)
    kopliksspots = models.CharField(max_length=255, blank=True, null=True)
    nausea = models.CharField(max_length=255, blank=True, null=True)
    neckstiffness = models.CharField(max_length=255, blank=True, null=True)
    onsetsymptom = models.CharField(max_length=512, blank=True, null=True)
    otitismedia = models.CharField(max_length=255, blank=True, null=True)
    refusalfeedordrink = models.CharField(max_length=255, blank=True, null=True)
    runnynose = models.CharField(max_length=255, blank=True, null=True)
    seizures = models.CharField(max_length=255, blank=True, null=True)
    symptomatic = models.BooleanField(blank=True, null=True)
    bloodinstool = models.CharField(max_length=255, blank=True, null=True)
    nosebleeding = models.CharField(max_length=255, blank=True, null=True)
    bloodyblackstool = models.CharField(max_length=255, blank=True, null=True)
    redbloodvomit = models.CharField(max_length=255, blank=True, null=True)
    coughingblood = models.CharField(max_length=255, blank=True, null=True)
    skinbruising = models.CharField(max_length=255, blank=True, null=True)
    bloodurine = models.CharField(max_length=255, blank=True, null=True)
    alteredconsciousness = models.CharField(max_length=255, blank=True, null=True)
    throbocytopenia = models.CharField(max_length=255, blank=True, null=True)
    hearingloss = models.CharField(max_length=255, blank=True, null=True)
    shock = models.CharField(max_length=255, blank=True, null=True)
    symptomscomments = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    lesions = models.CharField(max_length=255, blank=True, null=True)
    lesionssamestate = models.CharField(max_length=255, blank=True, null=True)
    lesionssamesize = models.CharField(max_length=255, blank=True, null=True)
    lesionsdeepprofound = models.CharField(max_length=255, blank=True, null=True)
    lesionsface = models.BooleanField(blank=True, null=True)
    lesionslegs = models.BooleanField(blank=True, null=True)
    lesionssolesfeet = models.BooleanField(blank=True, null=True)
    lesionspalmshands = models.BooleanField(blank=True, null=True)
    lesionsthorax = models.BooleanField(blank=True, null=True)
    lesionsarms = models.BooleanField(blank=True, null=True)
    lesionsgenitals = models.BooleanField(blank=True, null=True)
    lesionsalloverbody = models.BooleanField(blank=True, null=True)
    lesionsresembleimg1 = models.CharField(max_length=255, blank=True, null=True)
    lesionsresembleimg2 = models.CharField(max_length=255, blank=True, null=True)
    lesionsresembleimg3 = models.CharField(max_length=255, blank=True, null=True)
    lesionsresembleimg4 = models.CharField(max_length=255, blank=True, null=True)
    lymphadenopathyinguinal = models.CharField(max_length=255, blank=True, null=True)
    lymphadenopathyaxillary = models.CharField(max_length=255, blank=True, null=True)
    lymphadenopathycervical = models.CharField(max_length=255, blank=True, null=True)
    chillssweats = models.CharField(max_length=255, blank=True, null=True)
    lesionsthatitch = models.CharField(max_length=255, blank=True, null=True)
    bedridden = models.CharField(max_length=255, blank=True, null=True)
    oralulcers = models.CharField(max_length=255, blank=True, null=True)
    patientilllocation = models.CharField(max_length=512, blank=True, null=True)
    painfullymphadenitis = models.CharField(max_length=255, blank=True, null=True)
    buboesgroinarmpitneck = models.CharField(max_length=255, blank=True, null=True)
    blackeningdeathoftissue = models.CharField(max_length=255, blank=True, null=True)
    lesionsonsetdate = models.DateTimeField(blank=True, null=True)
    bulgingfontanelle = models.CharField(max_length=255, blank=True, null=True)
    meningealsigns = models.CharField(max_length=255, blank=True, null=True)
    bloodpressuresystolic = models.IntegerField(blank=True, null=True)
    bloodpressurediastolic = models.IntegerField(blank=True, null=True)
    heartrate = models.IntegerField(blank=True, null=True)
    pharyngealerythema = models.CharField(max_length=255, blank=True, null=True)
    pharyngealexudate = models.CharField(max_length=255, blank=True, null=True)
    oedemafaceneck = models.CharField(max_length=255, blank=True, null=True)
    oedemalowerextremity = models.CharField(max_length=255, blank=True, null=True)
    lossskinturgor = models.CharField(max_length=255, blank=True, null=True)
    palpableliver = models.CharField(max_length=255, blank=True, null=True)
    palpablespleen = models.CharField(max_length=255, blank=True, null=True)
    malaise = models.CharField(max_length=255, blank=True, null=True)
    sunkeneyesfontanelle = models.CharField(max_length=255, blank=True, null=True)
    sidepain = models.CharField(max_length=255, blank=True, null=True)
    fluidinlungcavity = models.CharField(max_length=255, blank=True, null=True)
    tremor = models.CharField(max_length=255, blank=True, null=True)
    hemorrhagicsyndrome = models.CharField(max_length=255, blank=True, null=True)
    hyperglycemia = models.CharField(max_length=255, blank=True, null=True)
    hypoglycemia = models.CharField(max_length=255, blank=True, null=True)
    sepsis = models.CharField(max_length=255, blank=True, null=True)
    midupperarmcircumference = models.IntegerField(blank=True, null=True)
    respiratoryrate = models.IntegerField(blank=True, null=True)
    weight = models.IntegerField(blank=True, null=True)
    height = models.IntegerField(blank=True, null=True)
    glasgowcomascale = models.IntegerField(blank=True, null=True)
    bilateralcataracts = models.CharField(max_length=255, blank=True, null=True)
    unilateralcataracts = models.CharField(max_length=255, blank=True, null=True)
    congenitalglaucoma = models.CharField(max_length=255, blank=True, null=True)
    pigmentaryretinopathy = models.CharField(max_length=255, blank=True, null=True)
    purpuricrash = models.CharField(max_length=255, blank=True, null=True)
    microcephaly = models.CharField(max_length=255, blank=True, null=True)
    developmentaldelay = models.CharField(max_length=255, blank=True, null=True)
    splenomegaly = models.CharField(max_length=255, blank=True, null=True)
    meningoencephalitis = models.CharField(max_length=255, blank=True, null=True)
    radiolucentbonedisease = models.CharField(max_length=255, blank=True, null=True)
    congenitalheartdisease = models.CharField(max_length=255, blank=True, null=True)
    congenitalheartdiseasetype = models.CharField(max_length=255, blank=True, null=True)
    congenitalheartdiseasedetails = models.CharField(max_length=512, blank=True, null=True)
    jaundicewithin24hoursofbirth = models.CharField(max_length=255, blank=True, null=True)
    hydrophobia = models.CharField(max_length=255, blank=True, null=True)
    opisthotonus = models.CharField(max_length=255, blank=True, null=True)
    anxietystates = models.CharField(max_length=255, blank=True, null=True)
    delirium = models.CharField(max_length=255, blank=True, null=True)
    uproariousness = models.CharField(max_length=255, blank=True, null=True)
    paresthesiaaroundwound = models.CharField(max_length=255, blank=True, null=True)
    excesssalivation = models.CharField(max_length=255, blank=True, null=True)
    insomnia = models.CharField(max_length=255, blank=True, null=True)
    paralysis = models.CharField(max_length=255, blank=True, null=True)
    excitation = models.CharField(max_length=255, blank=True, null=True)
    dysphagia = models.CharField(max_length=255, blank=True, null=True)
    aerophobia = models.CharField(max_length=255, blank=True, null=True)
    hyperactivity = models.CharField(max_length=255, blank=True, null=True)
    paresis = models.CharField(max_length=255, blank=True, null=True)
    agitation = models.CharField(max_length=255, blank=True, null=True)
    ascendingflaccidparalysis = models.CharField(max_length=255, blank=True, null=True)
    erraticbehaviour = models.CharField(max_length=255, blank=True, null=True)
    coma = models.CharField(max_length=255, blank=True, null=True)
    fluidinlungcavityauscultation = models.CharField(max_length=255, blank=True, null=True)
    fluidinlungcavityxray = models.CharField(max_length=255, blank=True, null=True)
    abnormallungxrayfindings = models.CharField(max_length=255, blank=True, null=True)
    conjunctivalinjection = models.CharField(max_length=255, blank=True, null=True)
    acuterespiratorydistresssyndrome = models.CharField(max_length=255, blank=True, null=True)
    pneumoniaclinicalorradiologic = models.CharField(max_length=255, blank=True, null=True)
    lossoftaste = models.CharField(max_length=255, blank=True, null=True)
    lossofsmell = models.CharField(max_length=255, blank=True, null=True)
    coughwithsputum = models.CharField(max_length=255, blank=True, null=True)
    coughwithheamoptysis = models.CharField(max_length=255, blank=True, null=True)
    lymphadenopathy = models.CharField(max_length=255, blank=True, null=True)
    wheezing = models.CharField(max_length=255, blank=True, null=True)
    skinulcers = models.CharField(max_length=255, blank=True, null=True)
    inabilitytowalk = models.CharField(max_length=255, blank=True, null=True)
    indrawingofchestwall = models.CharField(max_length=255, blank=True, null=True)
    othercomplications = models.CharField(max_length=255, blank=True, null=True)
    othercomplicationstext = models.CharField(max_length=512, blank=True, null=True)
    respiratorydiseaseventilation = models.CharField(max_length=255, blank=True, null=True)
    feelingill = models.CharField(max_length=255, blank=True, null=True)
    fastheartrate = models.CharField(max_length=255, blank=True, null=True)
    oxygensaturationlower94 = models.CharField(max_length=255, blank=True, null=True)
    feverishfeeling = models.CharField(max_length=255, blank=True, null=True)
    weakness = models.CharField(max_length=255, blank=True, null=True)
    fatigue = models.CharField(max_length=255, blank=True, null=True)
    coughwithoutsputum = models.CharField(max_length=255, blank=True, null=True)
    breathlessness = models.CharField(max_length=255, blank=True, null=True)
    chestpressure = models.CharField(max_length=255, blank=True, null=True)
    bluelips = models.CharField(max_length=255, blank=True, null=True)
    bloodcirculationproblems = models.CharField(max_length=255, blank=True, null=True)
    palpitations = models.CharField(max_length=255, blank=True, null=True)
    dizzinessstandingup = models.CharField(max_length=255, blank=True, null=True)
    highorlowbloodpressure = models.CharField(max_length=255, blank=True, null=True)
    urinaryretention = models.CharField(max_length=255, blank=True, null=True)
    shivering = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'symptoms_history'


class TaskHistory(SormasModel):
    assigneereply = models.CharField(max_length=4096, blank=True, null=True)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    creatorcomment = models.CharField(max_length=4096, blank=True, null=True)
    duedate = models.DateTimeField(blank=True, null=True)
    perceivedstart = models.DateTimeField(blank=True, null=True)
    statuschangedate = models.DateTimeField(blank=True, null=True)
    taskcontext = models.CharField(max_length=255, blank=True, null=True)
    taskstatus = models.CharField(max_length=255, blank=True, null=True)
    tasktype = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(max_length=36)
    assigneeuser_id = models.BigIntegerField(blank=True, null=True)
    caze_id = models.BigIntegerField(blank=True, null=True)
    creatoruser_id = models.BigIntegerField(blank=True, null=True)
    priority = models.CharField(max_length=255, blank=True, null=True)
    suggestedstart = models.DateTimeField(blank=True, null=True)
    contact_id = models.BigIntegerField(blank=True, null=True)
    event_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    closedlat = models.FloatField(blank=True, null=True)
    closedlon = models.FloatField(blank=True, null=True)
    closedlatlonaccuracy = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'task_history'


class Therapy(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'therapy'


class TherapyHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'therapy_history'


class TreatmentHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    therapy_id = models.BigIntegerField()
    treatmentdatetime = models.DateTimeField()
    executingclinician = models.CharField(max_length=512, blank=True, null=True)
    treatmenttype = models.CharField(max_length=255)
    treatmentdetails = models.CharField(max_length=512, blank=True, null=True)
    dose = models.CharField(max_length=512, blank=True, null=True)
    route = models.CharField(max_length=255, blank=True, null=True)
    routedetails = models.CharField(max_length=512, blank=True, null=True)
    additionalnotes = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    typeofdrug = models.CharField(max_length=255, blank=True, null=True)
    prescription_id = models.BigIntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'treatment_history'


class UserrolesUserrightsHistory(SormasModel):
    userright = models.CharField(max_length=255)
    sys_period = models.TextField()  # This field type is a guess.
    userrole_id = models.BigIntegerField()

    class Meta:
        managed = False
        db_table = 'userroles_userrights_history'


class Userrolesconfig(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    userrole = models.CharField(unique=True, max_length=255)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'userrolesconfig'


class UserrolesconfigHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    userrole = models.CharField(max_length=255)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'userrolesconfig_history'


class Users(SormasModel):
    active = models.BooleanField()
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    firstname = models.CharField(max_length=512)
    lastname = models.CharField(max_length=512)
    password = models.CharField(max_length=64)
    phone = models.CharField(max_length=255, blank=True, null=True)
    seed = models.CharField(max_length=16)
    useremail = models.CharField(max_length=255, blank=True, null=True)
    username = models.CharField(max_length=512)
    uuid = models.CharField(unique=True, max_length=36)
    address = models.ForeignKey(Location, models.DO_NOTHING, blank=True, null=True)
    associatedofficer = models.ForeignKey('self', models.DO_NOTHING, blank=True, null=True)
    region = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    healthfacility = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True)
    laboratory = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True,
                                   related_name='%(class)s_laboratory')
    sys_period = models.TextField()  # This field type is a guess.
    community = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    limiteddisease = models.CharField(max_length=255, blank=True, null=True)
    pointofentry = models.ForeignKey(Pointofentry, models.DO_NOTHING, blank=True, null=True)
    language = models.CharField(max_length=255, blank=True, null=True)
    hasconsentedtogdpr = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'users'


class UsersHistory(SormasModel):
    active = models.BooleanField()
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    firstname = models.CharField(max_length=512)
    lastname = models.CharField(max_length=512)
    password = models.CharField(max_length=64)
    phone = models.CharField(max_length=255, blank=True, null=True)
    seed = models.CharField(max_length=16)
    useremail = models.CharField(max_length=255, blank=True, null=True)
    username = models.CharField(max_length=512)
    uuid = models.CharField(max_length=36)
    address_id = models.BigIntegerField(blank=True, null=True)
    associatedofficer_id = models.BigIntegerField(blank=True, null=True)
    region_id = models.BigIntegerField(blank=True, null=True)
    district_id = models.BigIntegerField(blank=True, null=True)
    healthfacility_id = models.BigIntegerField(blank=True, null=True)
    laboratory_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    community = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    limiteddisease = models.CharField(max_length=255, blank=True, null=True)
    pointofentry_id = models.BigIntegerField(blank=True, null=True)
    language = models.CharField(max_length=255, blank=True, null=True)
    hasconsentedtogdpr = models.BooleanField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'users_history'


class UsersUserroles(SormasModel):
    user = models.ForeignKey(Users, models.DO_NOTHING)
    userrole = models.CharField(max_length=255)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'users_userroles'
        unique_together = (('user', 'userrole'),)


class UserrolesUserrights(SormasModel):
    userright = models.CharField(max_length=255)
    sys_period = models.TextField()  # This field type is a guess.
    userrole = models.ForeignKey(Userrolesconfig, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'userroles_userrights'
        unique_together = (('userrole', 'userright'),)


class Prescription(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    therapy = models.ForeignKey(Therapy, models.DO_NOTHING)
    prescriptiondate = models.DateTimeField()
    prescriptionstart = models.DateTimeField(blank=True, null=True)
    prescriptionend = models.DateTimeField(blank=True, null=True)
    prescribingclinician = models.CharField(max_length=512, blank=True, null=True)
    prescriptiontype = models.CharField(max_length=255)
    prescriptiondetails = models.CharField(max_length=512, blank=True, null=True)
    frequency = models.CharField(max_length=512, blank=True, null=True)
    dose = models.CharField(max_length=512, blank=True, null=True)
    route = models.CharField(max_length=255, blank=True, null=True)
    routedetails = models.CharField(max_length=512, blank=True, null=True)
    additionalnotes = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    typeofdrug = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'prescription'


class UsersUserrolesHistory(SormasModel):
    user_id = models.BigIntegerField()
    userrole = models.CharField(max_length=255)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'users_userroles_history'


class Clinicalvisit(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    clinicalcourse = models.ForeignKey(Clinicalcourse, models.DO_NOTHING)
    symptoms = models.ForeignKey(Symptoms, models.DO_NOTHING)
    disease = models.CharField(max_length=255, blank=True, null=True)
    visitdatetime = models.DateTimeField(blank=True, null=True)
    visitremarks = models.CharField(max_length=512, blank=True, null=True)
    visitingperson = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'clinicalvisit'


class EventparticipantHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    event_id = models.BigIntegerField(blank=True, null=True)
    person_id = models.BigIntegerField(blank=True, null=True)
    involvementdescription = models.CharField(max_length=255, blank=True, null=True)
    resultingcase_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    deleted = models.BooleanField(blank=True, null=True)
    reportinguser = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'eventparticipant_history'


class VisitHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    person_id = models.BigIntegerField()
    visituser_id = models.BigIntegerField()
    visitremarks = models.CharField(max_length=512, blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    visitdatetime = models.DateTimeField()
    visitstatus = models.CharField(max_length=255, blank=True, null=True)
    symptoms_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    caze_id = models.BigIntegerField(blank=True, null=True)
    origin = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'visit_history'


class Outbreak(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    district = models.ForeignKey(District, models.DO_NOTHING)
    disease = models.CharField(max_length=255)
    reportdate = models.DateTimeField()
    reportinguser = models.ForeignKey(Users, models.DO_NOTHING, related_name='%(class)s_reportinguser')
    sys_period = models.TextField()  # This field type is a guess.
    startdate = models.DateTimeField()
    enddate = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'outbreak'


class Weeklyreport(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    healthfacility = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True)
    reportinguser = models.ForeignKey(Users, models.DO_NOTHING, related_name='%(class)s_reportinguser')
    reportdatetime = models.DateTimeField()
    totalnumberofcases = models.IntegerField()
    year = models.IntegerField()
    epiweek = models.IntegerField()
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    community = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    assignedofficer = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    changedateofembeddedlists = models.DateTimeField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'weeklyreport'


class WeeklyreportHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    healthfacility_id = models.BigIntegerField(blank=True, null=True)
    reportinguser_id = models.BigIntegerField()
    reportdatetime = models.DateTimeField()
    totalnumberofcases = models.IntegerField()
    year = models.IntegerField()
    epiweek = models.IntegerField()
    district_id = models.BigIntegerField(blank=True, null=True)
    community_id = models.BigIntegerField(blank=True, null=True)
    assignedofficer_id = models.BigIntegerField(blank=True, null=True)
    changedateofembeddedlists = models.DateTimeField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'weeklyreport_history'


class Weeklyreportentry(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    weeklyreport = models.ForeignKey(Weeklyreport, models.DO_NOTHING)
    disease = models.CharField(max_length=255)
    numberofcases = models.IntegerField()
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'weeklyreportentry'


class WeeklyreportentryHistory(SormasModel):
    uuid = models.CharField(max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    weeklyreport_id = models.BigIntegerField()
    disease = models.CharField(max_length=255)
    numberofcases = models.IntegerField()
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'weeklyreportentry_history'


class Exportconfiguration(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=512, blank=True, null=True)
    user = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    exporttype = models.CharField(max_length=255, blank=True, null=True)
    propertiesstring = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'exportconfiguration'


class Cases(SormasModel):
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    description = models.CharField(max_length=4096, blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    investigateddate = models.DateTimeField(blank=True, null=True)
    reportdate = models.DateTimeField()
    uuid = models.CharField(unique=True, max_length=36)
    caseofficer = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True,
                                    related_name='%(class)s_caseofficer')
    healthfacility = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True)
    reportinguser = models.ForeignKey(Users, models.DO_NOTHING, related_name='%(class)s_reportinguser')
    surveillanceofficer = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    person = models.ForeignKey(Person, models.DO_NOTHING)
    symptoms = models.ForeignKey(Symptoms, models.DO_NOTHING, blank=True, null=True)
    region = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    community = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    caseclassification = models.CharField(max_length=255)
    investigationstatus = models.CharField(max_length=255)
    hospitalization = models.ForeignKey(Hospitalization, models.DO_NOTHING, blank=True, null=True)
    pregnant = models.CharField(max_length=255, blank=True, null=True)
    epidata = models.ForeignKey(Epidata, models.DO_NOTHING, blank=True, null=True)
    epidnumber = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    healthfacilitydetails = models.CharField(max_length=512, blank=True, null=True)
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    diseasedetails = models.CharField(max_length=512, blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    smallpoxvaccinationscar = models.CharField(max_length=255, blank=True, null=True)
    plaguetype = models.CharField(max_length=255, blank=True, null=True)
    smallpoxvaccinationreceived = models.CharField(max_length=255, blank=True, null=True)
    vaccinationdate = models.DateTimeField(blank=True, null=True)
    outcome = models.CharField(max_length=255, blank=True, null=True)
    outcomedate = models.DateTimeField(blank=True, null=True)
    vaccination = models.CharField(max_length=255, blank=True, null=True)
    vaccinationdoses = models.CharField(max_length=512, blank=True, null=True)
    vaccinationinfosource = models.CharField(max_length=255, blank=True, null=True)
    districtleveldate = models.DateTimeField(blank=True, null=True)
    caseage = models.IntegerField(blank=True, null=True)
    denguefevertype = models.CharField(max_length=255, blank=True, null=True)
    classificationcomment = models.CharField(max_length=512, blank=True, null=True)
    classificationdate = models.DateTimeField(blank=True, null=True)
    classificationuser = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True,
                                           related_name='%(class)s_classificationuser')
    systemcaseclassification = models.CharField(max_length=255)
    archived = models.BooleanField()
    therapy = models.ForeignKey(Therapy, models.DO_NOTHING, blank=True, null=True)
    clinicalcourse = models.ForeignKey(Clinicalcourse, models.DO_NOTHING, blank=True, null=True)
    sequelae = models.CharField(max_length=255, blank=True, null=True)
    sequelaedetails = models.CharField(max_length=512, blank=True, null=True)
    regionleveldate = models.DateTimeField(blank=True, null=True)
    nationalleveldate = models.DateTimeField(blank=True, null=True)
    cliniciandetails = models.CharField(max_length=512, blank=True, null=True)
    notifyingclinic = models.CharField(max_length=255, blank=True, null=True)
    notifyingclinicdetails = models.CharField(max_length=512, blank=True, null=True)
    maternalhistory = models.ForeignKey(Maternalhistory, models.DO_NOTHING, blank=True, null=True)
    creationversion = models.CharField(max_length=32, blank=True, null=True)
    caseorigin = models.CharField(max_length=255, blank=True, null=True)
    pointofentry = models.ForeignKey(Pointofentry, models.DO_NOTHING, blank=True, null=True)
    pointofentrydetails = models.CharField(max_length=512, blank=True, null=True)
    porthealthinfo = models.ForeignKey(Porthealthinfo, models.DO_NOTHING, blank=True, null=True)
    clinicianphone = models.CharField(max_length=512, blank=True, null=True)
    clinicianemail = models.CharField(max_length=512, blank=True, null=True)
    duplicateof = models.ForeignKey('self', models.DO_NOTHING, blank=True, null=True)
    completeness = models.FloatField(blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    vaccine = models.CharField(max_length=512, blank=True, null=True)
    rabiestype = models.CharField(max_length=255, blank=True, null=True)
    additionaldetails = models.CharField(max_length=4096, blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)
    sharedtocountry = models.BooleanField(blank=True, null=True)
    quarantine = models.CharField(max_length=255, blank=True, null=True)
    quarantinefrom = models.DateTimeField(blank=True, null=True)
    quarantineto = models.DateTimeField(blank=True, null=True)
    quarantinehelpneeded = models.CharField(max_length=512, blank=True, null=True)
    quarantineorderedverbally = models.BooleanField(blank=True, null=True)
    quarantineorderedofficialdocument = models.BooleanField(blank=True, null=True)
    quarantineorderedverballydate = models.DateTimeField(blank=True, null=True)
    quarantineorderedofficialdocumentdate = models.DateTimeField(blank=True, null=True)
    quarantinehomepossible = models.CharField(max_length=255, blank=True, null=True)
    quarantinehomepossiblecomment = models.CharField(max_length=512, blank=True, null=True)
    quarantinehomesupplyensured = models.CharField(max_length=255, blank=True, null=True)
    quarantinehomesupplyensuredcomment = models.CharField(max_length=512, blank=True, null=True)
    reportingtype = models.CharField(max_length=255, blank=True, null=True)
    postpartum = models.CharField(max_length=255, blank=True, null=True)
    trimester = models.CharField(max_length=255, blank=True, null=True)
    quarantinetypedetails = models.CharField(max_length=512, blank=True, null=True)
    clinicalconfirmation = models.CharField(max_length=255, blank=True, null=True)
    epidemiologicalconfirmation = models.CharField(max_length=255, blank=True, null=True)
    laboratorydiagnosticconfirmation = models.CharField(max_length=255, blank=True, null=True)
    quarantineextended = models.BooleanField(blank=True, null=True)
    followupstatus = models.CharField(max_length=255, blank=True, null=True)
    followupcomment = models.CharField(max_length=4096, blank=True, null=True)
    followupuntil = models.DateTimeField(blank=True, null=True)
    overwritefollowupuntil = models.BooleanField(blank=True, null=True)
    facilitytype = models.CharField(max_length=255, blank=True, null=True)
    quarantineofficialordersent = models.BooleanField(blank=True, null=True)
    quarantineofficialordersentdate = models.DateTimeField(blank=True, null=True)
    quarantinereduced = models.BooleanField(blank=True, null=True)
    caseidism = models.IntegerField(blank=True, null=True)
    covidtestreason = models.CharField(max_length=255, blank=True, null=True)
    covidtestreasondetails = models.CharField(max_length=512, blank=True, null=True)
    contacttracingfirstcontacttype = models.CharField(max_length=255, blank=True, null=True)
    contacttracingfirstcontactdate = models.DateTimeField(blank=True, null=True)
    quarantinereasonbeforeisolation = models.CharField(max_length=255, blank=True, null=True)
    quarantinereasonbeforeisolationdetails = models.CharField(max_length=512, blank=True, null=True)
    endofisolationreason = models.CharField(max_length=255, blank=True, null=True)
    endofisolationreasondetails = models.CharField(max_length=512, blank=True, null=True)
    sormastosormasorigininfo = models.ForeignKey(Sormastosormasorigininfo, models.DO_NOTHING, blank=True, null=True)
    wasinquarantinebeforeisolation = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'cases'


class Contact(SormasModel):
    changedate = models.DateTimeField()
    contactproximity = models.CharField(max_length=255, blank=True, null=True)
    creationdate = models.DateTimeField()
    lastcontactdate = models.DateTimeField(blank=True, null=True)
    reportdatetime = models.DateTimeField()
    uuid = models.CharField(unique=True, max_length=36)
    caze = models.ForeignKey(Cases, models.DO_NOTHING, blank=True, null=True, related_name='%(class)s_caze')
    person = models.ForeignKey(Person, models.DO_NOTHING)
    reportinguser = models.ForeignKey(Users, models.DO_NOTHING, related_name='%(class)s_reportinguser')
    description = models.CharField(max_length=4096, blank=True, null=True)
    contactofficer = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    contactclassification = models.CharField(max_length=255, blank=True, null=True)
    followupstatus = models.CharField(max_length=255, blank=True, null=True)
    followupuntil = models.DateTimeField(blank=True, null=True)
    relationtocase = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    followupcomment = models.CharField(max_length=4096, blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    contactstatus = models.CharField(max_length=255, blank=True, null=True)
    resultingcase = models.ForeignKey(Cases, models.DO_NOTHING, blank=True, null=True)
    resultingcaseuser = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True,
                                          related_name='%(class)s_resultingcaseuser')
    deleted = models.BooleanField(blank=True, null=True)
    relationdescription = models.CharField(max_length=512, blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)
    region = models.ForeignKey(Region, models.DO_NOTHING, blank=True, null=True)
    district = models.ForeignKey(District, models.DO_NOTHING, blank=True, null=True)
    highpriority = models.BooleanField(blank=True, null=True)
    immunosuppressivetherapybasicdisease = models.CharField(max_length=255, blank=True, null=True)
    immunosuppressivetherapybasicdiseasedetails = models.CharField(max_length=512, blank=True, null=True)
    careforpeopleover60 = models.CharField(max_length=255, blank=True, null=True)
    quarantine = models.CharField(max_length=255, blank=True, null=True)
    quarantinefrom = models.DateTimeField(blank=True, null=True)
    quarantineto = models.DateTimeField(blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    diseasedetails = models.CharField(max_length=512, blank=True, null=True)
    caseidexternalsystem = models.CharField(max_length=512, blank=True, null=True)
    caseoreventinformation = models.CharField(max_length=4096, blank=True, null=True)
    contactcategory = models.CharField(max_length=255, blank=True, null=True)
    contactproximitydetails = models.CharField(max_length=512, blank=True, null=True)
    overwritefollowupuntil = models.BooleanField(blank=True, null=True)
    quarantinehelpneeded = models.CharField(max_length=512, blank=True, null=True)
    quarantineorderedverbally = models.BooleanField(blank=True, null=True)
    quarantineorderedofficialdocument = models.BooleanField(blank=True, null=True)
    quarantineorderedverballydate = models.DateTimeField(blank=True, null=True)
    quarantineorderedofficialdocumentdate = models.DateTimeField(blank=True, null=True)
    quarantinehomepossible = models.CharField(max_length=255, blank=True, null=True)
    quarantinehomepossiblecomment = models.CharField(max_length=512, blank=True, null=True)
    quarantinehomesupplyensured = models.CharField(max_length=255, blank=True, null=True)
    quarantinehomesupplyensuredcomment = models.CharField(max_length=512, blank=True, null=True)
    additionaldetails = models.CharField(max_length=4096, blank=True, null=True)
    quarantinetypedetails = models.CharField(max_length=512, blank=True, null=True)
    epidata = models.ForeignKey(Epidata, models.DO_NOTHING, blank=True, null=True)
    contactidentificationsource = models.CharField(max_length=255, blank=True, null=True)
    contactidentificationsourcedetails = models.CharField(max_length=512, blank=True, null=True)
    tracingapp = models.CharField(max_length=255, blank=True, null=True)
    tracingappdetails = models.CharField(max_length=512, blank=True, null=True)
    quarantineextended = models.BooleanField(blank=True, null=True)
    community = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    healthconditions = models.ForeignKey(Healthconditions, models.DO_NOTHING, blank=True, null=True)
    quarantineofficialordersent = models.BooleanField(blank=True, null=True)
    quarantineofficialordersentdate = models.DateTimeField(blank=True, null=True)
    quarantinereduced = models.BooleanField(blank=True, null=True)
    endofquarantinereason = models.CharField(max_length=255, blank=True, null=True)
    endofquarantinereasondetails = models.CharField(max_length=512, blank=True, null=True)
    returningtraveler = models.CharField(max_length=255, blank=True, null=True)
    sormastosormasorigininfo = models.ForeignKey(Sormastosormasorigininfo, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'contact'


class Treatment(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    therapy = models.ForeignKey(Therapy, models.DO_NOTHING)
    treatmentdatetime = models.DateTimeField()
    executingclinician = models.CharField(max_length=512, blank=True, null=True)
    treatmenttype = models.CharField(max_length=255)
    treatmentdetails = models.CharField(max_length=512, blank=True, null=True)
    dose = models.CharField(max_length=512, blank=True, null=True)
    route = models.CharField(max_length=255, blank=True, null=True)
    routedetails = models.CharField(max_length=512, blank=True, null=True)
    additionalnotes = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    typeofdrug = models.CharField(max_length=255, blank=True, null=True)
    prescription = models.ForeignKey(Prescription, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'treatment'


class Events(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    eventstatus = models.CharField(max_length=255)
    eventdesc = models.CharField(max_length=4096, blank=True, null=True)
    startdate = models.DateTimeField(blank=True, null=True)
    reportdatetime = models.DateTimeField()
    reportinguser = models.ForeignKey(Users, models.DO_NOTHING, related_name='%(class)s_reportinguser')
    eventlocation = models.ForeignKey(Location, models.DO_NOTHING, blank=True, null=True)
    typeofplace = models.CharField(max_length=255, blank=True, null=True)
    srcfirstname = models.CharField(max_length=512, blank=True, null=True)
    srclastname = models.CharField(max_length=512, blank=True, null=True)
    srctelno = models.CharField(max_length=512, blank=True, null=True)
    srcemail = models.CharField(max_length=512, blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    surveillanceofficer = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    typeofplacetext = models.CharField(max_length=512, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    diseasedetails = models.CharField(max_length=512, blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    archived = models.BooleanField()
    deleted = models.BooleanField(blank=True, null=True)
    enddate = models.DateTimeField(blank=True, null=True)
    externalid = models.CharField(max_length=512, blank=True, null=True)
    nosocomial = models.CharField(max_length=255, blank=True, null=True)
    srctype = models.CharField(max_length=255, blank=True, null=True)
    srcmediawebsite = models.CharField(max_length=512, blank=True, null=True)
    srcmedianame = models.CharField(max_length=512, blank=True, null=True)
    srcmediadetails = models.CharField(max_length=4096, blank=True, null=True)
    eventtitle = models.CharField(max_length=512, blank=True, null=True)
    eventinvestigationstatus = models.CharField(max_length=255, blank=True, null=True)
    eventinvestigationstartdate = models.DateTimeField(blank=True, null=True)
    eventinvestigationenddate = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'events'


class Action(SormasModel):
    reply = models.CharField(max_length=4096, blank=True, null=True)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    description = models.CharField(max_length=4096, blank=True, null=True)
    date = models.DateTimeField(blank=True, null=True)
    statuschangedate = models.DateTimeField(blank=True, null=True)
    actioncontext = models.CharField(max_length=512, blank=True, null=True)
    actionstatus = models.CharField(max_length=512, blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=36)
    event = models.ForeignKey(Events, models.DO_NOTHING, blank=True, null=True)
    creatoruser = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    priority = models.CharField(max_length=512, blank=True, null=True)
    replyinguser_id = models.BigIntegerField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    title = models.CharField(max_length=512, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'action'


class Task(SormasModel):
    assigneereply = models.CharField(max_length=4096, blank=True, null=True)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    creatorcomment = models.CharField(max_length=4096, blank=True, null=True)
    duedate = models.DateTimeField(blank=True, null=True)
    perceivedstart = models.DateTimeField(blank=True, null=True)
    statuschangedate = models.DateTimeField(blank=True, null=True)
    taskcontext = models.CharField(max_length=255, blank=True, null=True)
    taskstatus = models.CharField(max_length=255, blank=True, null=True)
    tasktype = models.CharField(max_length=255, blank=True, null=True)
    uuid = models.CharField(unique=True, max_length=36)
    assigneeuser = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True,
                                     related_name='%(class)s_assigneeuser')
    caze = models.ForeignKey(Cases, models.DO_NOTHING, blank=True, null=True)
    creatoruser = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    priority = models.CharField(max_length=255, blank=True, null=True)
    suggestedstart = models.DateTimeField(blank=True, null=True)
    contact = models.ForeignKey(Contact, models.DO_NOTHING, blank=True, null=True)
    event = models.ForeignKey(Events, models.DO_NOTHING, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    closedlat = models.FloatField(blank=True, null=True)
    closedlon = models.FloatField(blank=True, null=True)
    closedlatlonaccuracy = models.FloatField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'task'


class Campaigns(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    name = models.CharField(max_length=255, blank=True, null=True)
    description = models.CharField(max_length=4096, blank=True, null=True)
    startdate = models.DateTimeField(blank=True, null=True)
    enddate = models.DateTimeField(blank=True, null=True)
    creatinguser = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    archived = models.BooleanField(blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    dashboardelements = models.TextField(blank=True, null=True)  # This field type is a guess.


class CampaignCampaignformmeta(SormasModel):
    campaign = models.ForeignKey(Campaigns, models.DO_NOTHING)
    campaignformmeta = models.ForeignKey('Campaignformmeta', models.DO_NOTHING)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'campaign_campaignformmeta'
        unique_together = (('campaign', 'campaignformmeta'),)


class Visit(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    person = models.ForeignKey(Person, models.DO_NOTHING)
    visituser = models.ForeignKey(Users, models.DO_NOTHING)
    visitremarks = models.CharField(max_length=512, blank=True, null=True)
    disease = models.CharField(max_length=255, blank=True, null=True)
    visitdatetime = models.DateTimeField()
    visitstatus = models.CharField(max_length=255, blank=True, null=True)
    symptoms = models.ForeignKey(Symptoms, models.DO_NOTHING, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    caze = models.ForeignKey(Cases, models.DO_NOTHING, blank=True, null=True)
    origin = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'visit'


class ContactsVisits(SormasModel):
    contact = models.ForeignKey(Contact, models.DO_NOTHING)
    visit = models.ForeignKey(Visit, models.DO_NOTHING)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'contacts_visits'
        unique_together = (('contact', 'visit'),)


class Eventparticipant(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    event = models.ForeignKey(Events, models.DO_NOTHING, blank=True, null=True)
    person = models.ForeignKey(Person, models.DO_NOTHING, blank=True, null=True)
    involvementdescription = models.CharField(max_length=255, blank=True, null=True)
    resultingcase = models.ForeignKey(Cases, models.DO_NOTHING, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    deleted = models.BooleanField(blank=True, null=True)
    reportinguser = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'eventparticipant'


class Samples(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    associatedcase = models.ForeignKey(Cases, models.DO_NOTHING, blank=True, null=True)
    samplecode = models.CharField(max_length=512, blank=True, null=True)
    sampledatetime = models.DateTimeField()
    reportdatetime = models.DateTimeField()
    reportinguser = models.ForeignKey(Users, models.DO_NOTHING, related_name='%(class)s_reportinguser')
    samplematerial = models.CharField(max_length=255)
    samplematerialtext = models.CharField(max_length=512, blank=True, null=True)
    lab = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True, related_name='%(class)s_lab')
    otherlab = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True)
    shipmentdate = models.DateTimeField(blank=True, null=True)
    shipmentdetails = models.CharField(max_length=512, blank=True, null=True)
    receiveddate = models.DateTimeField(blank=True, null=True)
    notestpossiblereason = models.CharField(max_length=512, blank=True, null=True)
    comment = models.CharField(max_length=4096, blank=True, null=True)
    specimencondition = models.CharField(max_length=255, blank=True, null=True)
    labsampleid = models.CharField(max_length=512, blank=True, null=True)
    samplesource = models.CharField(max_length=255, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    referredto = models.ForeignKey('self', models.DO_NOTHING, blank=True, null=True)
    shipped = models.BooleanField(blank=True, null=True)
    received = models.BooleanField(blank=True, null=True)
    reportlat = models.FloatField(blank=True, null=True)
    reportlon = models.FloatField(blank=True, null=True)
    reportlatlonaccuracy = models.FloatField(blank=True, null=True)
    labdetails = models.CharField(max_length=512, blank=True, null=True)
    pathogentestingrequested = models.BooleanField(blank=True, null=True)
    additionaltestingrequested = models.BooleanField(blank=True, null=True)
    requestedpathogentestsstring = models.CharField(max_length=512, blank=True, null=True)
    requestedadditionaltestsstring = models.CharField(max_length=512, blank=True, null=True)
    pathogentestresult = models.CharField(max_length=255, blank=True, null=True)
    requestedotherpathogentests = models.CharField(max_length=512, blank=True, null=True)
    requestedotheradditionaltests = models.CharField(max_length=512, blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    pathogentestresultchangedate = models.DateTimeField(blank=True, null=True)
    samplepurpose = models.CharField(max_length=255)
    fieldsampleid = models.CharField(max_length=512, blank=True, null=True)
    associatedcontact = models.ForeignKey(Contact, models.DO_NOTHING, blank=True, null=True)
    associatedeventparticipant = models.ForeignKey(Eventparticipant, models.DO_NOTHING, blank=True, null=True)
    sormastosormasorigininfo = models.ForeignKey(Sormastosormasorigininfo, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'samples'


class Pathogentest(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    sample = models.ForeignKey(Samples, models.DO_NOTHING)
    testtype = models.CharField(max_length=255)
    testtypetext = models.CharField(max_length=512, blank=True, null=True)
    testdatetime = models.DateTimeField()
    lab = models.ForeignKey(Facility, models.DO_NOTHING, blank=True, null=True)
    labuser = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    testresult = models.CharField(max_length=255)
    testresulttext = models.CharField(max_length=4096, blank=True, null=True)
    testresultverified = models.BooleanField()
    sys_period = models.TextField()  # This field type is a guess.
    fourfoldincreaseantibodytiter = models.BooleanField(blank=True, null=True)
    labdetails = models.CharField(max_length=512, blank=True, null=True)
    testeddisease = models.CharField(max_length=255, blank=True, null=True)
    testeddiseasedetails = models.CharField(max_length=512, blank=True, null=True)
    deleted = models.BooleanField(blank=True, null=True)
    serotype = models.CharField(max_length=512, blank=True, null=True)
    cqvalue = models.FloatField(blank=True, null=True)


class Additionaltest(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    sample = models.ForeignKey(Samples, models.DO_NOTHING)
    testdatetime = models.DateTimeField()
    haemoglobinuria = models.CharField(max_length=255, blank=True, null=True)
    proteinuria = models.CharField(max_length=255, blank=True, null=True)
    hematuria = models.CharField(max_length=255, blank=True, null=True)
    arterialvenousgasph = models.FloatField(blank=True, null=True)
    arterialvenousgaspco2 = models.FloatField(blank=True, null=True)
    arterialvenousgaspao2 = models.FloatField(blank=True, null=True)
    arterialvenousgashco3 = models.FloatField(blank=True, null=True)
    gasoxygentherapy = models.FloatField(blank=True, null=True)
    altsgpt = models.FloatField(blank=True, null=True)
    astsgot = models.FloatField(blank=True, null=True)
    creatinine = models.FloatField(blank=True, null=True)
    potassium = models.FloatField(blank=True, null=True)
    urea = models.FloatField(blank=True, null=True)
    haemoglobin = models.FloatField(blank=True, null=True)
    totalbilirubin = models.FloatField(blank=True, null=True)
    conjbilirubin = models.FloatField(blank=True, null=True)
    wbccount = models.FloatField(blank=True, null=True)
    platelets = models.FloatField(blank=True, null=True)
    prothrombintime = models.FloatField(blank=True, null=True)
    othertestresults = models.CharField(max_length=4096, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.

    class Meta:
        managed = False
        db_table = 'additionaltest'


class Campaignformdata(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    changedate = models.DateTimeField()
    creationdate = models.DateTimeField()
    formvalues = models.TextField(blank=True, null=True)  # This field type is a guess.
    campaign = models.ForeignKey(Campaigns, models.DO_NOTHING)
    campaignformmeta = models.ForeignKey(Campaignformmeta, models.DO_NOTHING)
    region = models.ForeignKey(Region, models.DO_NOTHING)
    district = models.ForeignKey(District, models.DO_NOTHING)
    community = models.ForeignKey(Community, models.DO_NOTHING, blank=True, null=True)
    sys_period = models.TextField()  # This field type is a guess.
    archived = models.BooleanField()
    formdate = models.DateTimeField(blank=True, null=True)
    creatinguser = models.ForeignKey('Users', models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'campaignformdata'


class Sormastosormasshareinfo(SormasModel):
    uuid = models.CharField(unique=True, max_length=36)
    creationdate = models.DateTimeField()
    changedate = models.DateTimeField()
    caze = models.ForeignKey(Cases, models.DO_NOTHING, blank=True, null=True)
    contact = models.ForeignKey(Contact, models.DO_NOTHING, blank=True, null=True)
    organizationid = models.CharField(max_length=512, blank=True, null=True)
    sender = models.ForeignKey(Users, models.DO_NOTHING, blank=True, null=True)
    ownershiphandedover = models.BooleanField()
    comment = models.CharField(max_length=4096, blank=True, null=True)
    sample = models.ForeignKey(Samples, models.DO_NOTHING, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sormastosormasshareinfo'
