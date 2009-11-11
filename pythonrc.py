#!/usr/bin/python
import sys, os, readline, rlcompleter, atexit, pprint, __builtin__, __main__
from tempfile import mkstemp
from code import InteractiveConsole

class TermColors(dict):
    COLOR_TEMPLATES = (
        ("Black"       , "0;30"),
        ("Red"         , "0;31"),
        ("Green"       , "0;32"),
        ("Brown"       , "0;33"),
        ("Blue"        , "0;34"),
        ("Purple"      , "0;35"),
        ("Cyan"        , "0;36"),
        ("LightGray"   , "0;37"),
        ("DarkGray"    , "1;30"),
        ("LightRed"    , "1;31"),
        ("LightGreen"  , "1;32"),
        ("Yellow"      , "1;33"),
        ("LightBlue"   , "1;34"),
        ("LightPurple" , "1;35"),
        ("LightCyan"   , "1;36"),
        ("White"       , "1;37"),
        ("Normal"      , "0"),
    )

    NoColor = ''
    _base = '\001\033[%sm\002'

    def __init__(self):
        if os.environ.get('TERM') in ('xterm-color', 'xterm-256color', 'linux',
                                      'screen', 'screen-256color', 'screen-bce'):
            self.update(dict([(k, self._base % v) for k,v in self.COLOR_TEMPLATES]))
        else:
            self.update(dict([(k, self.NoColor) for k,v in self.COLOR_TEMPLATES]))

_c = TermColors()

try:
    import readline
except ImportError:
    print "No readline support"
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")

histfile = os.path.join(os.environ["HOME"], ".python_history")
readline.set_history_length(300)
try:
    readline.read_history_file(histfile)
except IOError:
    pass

atexit.register(readline.write_history_file, histfile)

sys.ps1 = '%s>>> %s' % (_c['Green'], _c['Normal'])
sys.ps2 = '%s... %s' % (_c['Red'], _c['Normal'])

def my_displayhook(value):
    if value is not None:
        __builtin__._ = value
        pprint.pprint(value)
sys.displayhook = my_displayhook

WELCOME = ""

# Django helpers

def SECRET_KEY():
    "Generates a new SECRET_KEY that can be used in a project settings file." 

    from random import choice
    return ''.join(
            [choice('abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)')
                for i in range(50)])

# If we're working with a Django project, set up the test environment
if os.environ.has_key('DJANGO_SETTINGS_MODULE'):
    from django.db.models.loading import get_models
    from django.test.client import Client
    from django.test.utils import setup_test_environment, teardown_test_environment

    class DjangoModels(object):
        def __init__(self):
            for m in get_models():
                setattr(self, m.__name__, m)

    A = DjangoModels()
    C = Client()
    setup_test_environment()

    WELCOME += """%(LightBlue)s
Django environment detected.
* Your INSTALLED_APPS models have been imported into the namespace `A`.
* The Django test client is available as `C`.
* The Django test environment has been set up. To restore the normal
  environment call `teardown_test_environment()`.
%(Normal)s""" % _c

c = InteractiveConsole(locals=locals())
c.interact(banner=WELCOME)

sys.exit()

