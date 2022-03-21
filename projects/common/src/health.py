import django

def status():
    return {"status": "DOWN", "version": django.get_version()}
