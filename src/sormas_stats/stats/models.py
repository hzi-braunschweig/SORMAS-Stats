from django.db import models


class SormasModel(models.Model):
    id = models.BigIntegerField(primary_key=True)

    class Meta:
        abstract = True


class SormasRouter:
    """
    A router to control all database operations on models in the SORMAS DB
    """
    route_app_labels = {'sormas'}

    def db_for_read(self, model, **hints):
        """
        Attempts to read SORMAS models go to SORMAS DB
        """
        if issubclass(model, SormasModel):
            return 'sormas'
        return None


class StatsModel(models.Model):
    class Meta:
        abstract = True


class CasesPerDay(StatsModel):
    date = models.DateField(primary_key=True)
    count = models.PositiveIntegerField()


class ContactNetworkNodes(StatsModel):
    GROUP_CHOICES = [
        ('HEALTHY', 'HEALTHY'),
        ('NOT_CLASSIFIED', 'NOT_CLASSIFIED')
    ]

    SHAPE_CHOICES = [
        ('icon', 'icon')
    ]

    id = models.PositiveIntegerField(primary_key=True)
    group = models.CharField(max_length=16, choices=GROUP_CHOICES)
    shape = models.CharField(max_length=4, choices=SHAPE_CHOICES)


class ContactNetworkEdges(StatsModel):
    source = models.ForeignKey('ContactNetworkNodes', on_delete=models.DO_NOTHING,
                               related_name='%(class)s_source')
    target = models.ForeignKey('ContactNetworkNodes', on_delete=models.DO_NOTHING)
    label = models.CharField(max_length=32)
    dashes = models.CharField(max_length=32)

    class Meta:
        unique_together = (("source", "target"),)
