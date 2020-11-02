import random
import uuid
from datetime import datetime


def duuid():
    uuid.UUID(int=random.getrandbits(128))


def dnow():
    # FIXME(@JonasCir) make deterministic
    return datetime.now()
