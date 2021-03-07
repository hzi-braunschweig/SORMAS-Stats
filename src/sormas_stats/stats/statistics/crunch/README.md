# Number crunching

## base

Abstract class to enforce the fetch, compute, flush, and store cycle.

## cases_per_day

Compute the number of Covid-19 cases per day.

## contact_network

Compute the contact network of all index persons in SORMAS.

## Development

### How to use your IDE debugger 
As django does some internal setup, you need to insert some boiler plate code to 
use your debugger to step through the files in this folder. Just add the following
snippet at the end of your file you want to debug.
```python
def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'sormas_stats.settings')

    django.setup()

    cont = Contacts() # Change this to the class in the file
    cont.fetch()


if __name__ == '__main__':
    main()
```

Further, you might need to temporarily move some imports into the function you are
testing due to missing Django initialization, for example:
```python
class Contacts(Stats):

    def fetch(self):
        from stats.sormas_models import Cases, Region
        from stats.sormas_models import Contact
        from stats.sormas_models import District
        case_col = ['id','disease']
```