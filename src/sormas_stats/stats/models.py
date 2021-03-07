from django.db import models


class SormasModel(models.Model):
    """
    Super class of all models which are imported from SORMAS DB.
    See `sormas_models.py` for details.
    """
    id = models.BigIntegerField(primary_key=True)

    class Meta:
        abstract = True


# todo test for readonly access.

class SormasRouter:
    """
    A router to control all database operations on models in the SORMAS DB.
    Enforces read only access to main SORMAS DB.
    """
    route_app_labels = {'sormas'}

    def db_for_read(self, model, **hints):
        """
        Attempts to read SORMAS models go to SORMAS DB.
        """
        if issubclass(model, SormasModel):
            return 'sormas'
        return None


class StatsModel(models.Model):
    """
    Super class for all DB models of SORMAS-Stats.
    """

    class Meta:
        abstract = True


class CasesPerDay(StatsModel):
    """
    Store how many cases per day where reported.
    """
    date = models.DateField(primary_key=True)
    count = models.PositiveIntegerField()


class ContactNetworkNodes(StatsModel):
    """
    Store the nodes of the contact network.
    """
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
    """
    Store the edges of the contact network.
    """
    source = models.ForeignKey(
        'ContactNetworkNodes',
        on_delete=models.DO_NOTHING,
        related_name='%(class)s_source'
    )

    target = models.ForeignKey(
        'ContactNetworkNodes',
        on_delete=models.DO_NOTHING
    )

    # todo introduce choices for this
    label = models.CharField(max_length=32)
    dashes = models.CharField(max_length=32)

    class Meta:
        unique_together = (("source", "target"),)
