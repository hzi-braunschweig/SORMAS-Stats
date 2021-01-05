from django.db import models


class CasesPerDay(models.Model):
    date = models.DateField()
    number = models.PositiveIntegerField()
