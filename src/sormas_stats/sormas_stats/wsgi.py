"""
WSGI config for sormas_stats project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.1/howto/deployment/wsgi/
"""

import os
import sys
from os.path import abspath, dirname

from django.core.wsgi import get_wsgi_application

sys.path.append(dirname(dirname(abspath(__file__))))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'sormas_stats.settings')

application = get_wsgi_application()
