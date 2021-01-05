from os.path import join, dirname

from django.apps import AppConfig


class StatsConfig(AppConfig):
    name = 'stats'
    R_SOURCE = join(dirname(__file__), 'statistics', 'R')
