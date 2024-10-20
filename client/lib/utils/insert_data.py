from bs4 import BeautifulSoup
import requests
import json

class Category:
    def __init__(self, id):
        self.id = id

# Mappa delle categorie con solo l'id
categories = {
    'Horror': Category(1),
    'Thriller': Category(2),
    'Mistero': Category(3),
    'Romantico': Category(4),
    'Fantasy': Category(5),
    'Drammatico': Category(6),
    'Avventura': Category(7),
    'Fantascienza': Category(8),
}

biographies = {
    "Christopher Nolan": "Nato a Londra, Regno Unito. Ha vinto numerosi premi, incluso un Oscar per 'Inception'.",
    "Alfred Hitchcock": "Nato a Londra, morto a Los Angeles. Considerato uno dei migliori registi thriller, noto per 'Psycho'.",
    "Steven Spielberg": "Nato a Cincinnati, USA. Ha vinto il premio Oscar per 'Schindler's List'.",
    "Guillermo del Toro": "Nato a Guadalajara, Messico. Ha vinto l'Oscar per 'The Shape of Water'.",
    "Quentin Tarantino": "Nato a Knoxville, USA. Vincitore di due Oscar per la miglior sceneggiatura.",
    "James Cameron": "Nato a Kapuskasing, Canada. Ha vinto l'Oscar per 'Titanic'."
}

def login(base_url, username, password):
    endpoint = '/login'
    url = f'{base_url}{endpoint}'

    headers = {'Content-Type': 'application/json'}
    payload = {
        'username': username,
        'password': password
    }

    try:
        response = requests.post(
            url,
            headers=headers,
            data=json.dumps(payload),
        )
        response.raise_for_status()  # Solleva eccezione per stati di errore HTTP
        responseData = response.json()
        return responseData.get('token')  # Assicurati che il campo 'token' sia presente
    except requests.RequestException as e:
        print(f"Errore durante il login: {e}")
        return None

def get_image_url(page_name):
    search_url = f"https://en.wikipedia.org/wiki/{page_name.replace(' ', '_')}"
    try:
        response = requests.get(search_url)
        response.raise_for_status()  # Verifica la riuscita della richiesta
        soup = BeautifulSoup(response.content, 'html.parser')
        infobox = soup.find('table', class_='infobox')
        if infobox:
            image = infobox.find('img')
            if image:
                return 'https:' + image['src']
        return None
    except requests.RequestException as e:
        print(f"Errore durante il recupero dell'immagine per {page_name}: {e}")
        return None

def add_movie(base_url, token, title, year, image_url, director_id):
    endpoint = '/movies'
    url = f'{base_url}{endpoint}'

    headers = {
        'Content-Type': 'application/json',
        'token': token
    }
    payload = {
        'title': title,
        'year': year,
        'image_url': image_url,
        'director_id': director_id,
    }

    try:
        response = requests.post(
            url,
            headers=headers,
            data=json.dumps(payload),
        )
        response.raise_for_status()
        return True
    except requests.RequestException as e:
        print(f"Errore nell'aggiungere il film '{title}': {e}")
        return False

def add_director(base_url, token, name, image_url, biography, category_id):
    endpoint = '/directors'
    url = f'{base_url}{endpoint}'

    headers = {
        'Content-Type': 'application/json',
        'token': token  
    }
    payload = {
        'name': name,
        'image_url': image_url,
        'biography': biography,
        'categories_id': category_id
    }

    try:
        response = requests.post(
            url,
            headers=headers,
            data=json.dumps(payload),
        )
        response.raise_for_status()
        return True
    except requests.RequestException as e:
        print(f"Errore nell'aggiungere il regista '{name}': {e}")
        return False

def main():
    base_url = 'http://172.18.0.3:5000'

    # Effettua il login per ottenere il token
    token = login(base_url, 'a', '12345678a')
    
    if not token:
        print("Errore: impossibile ottenere il token. Uscita.")
        return

    # Lista di registi
    directors = [
        ("Alfred Hitchcock", biographies["Alfred Hitchcock"], categories['Thriller'].id),
        ("Guillermo del Toro", biographies["Guillermo del Toro"], categories['Horror'].id),
        ("James Cameron", biographies["James Cameron"], categories['Avventura'].id)
    ]

    # Lista di film
    movies = [
        ("Psycho", 1960, "Psycho", 2),
        ("Jurassic Park", 1993, "Jurassic_Park", 3),
        ("The Shape of Water", 2017, "The_Shape_of_Water", 4),
        ("Avatar", 2009, "Avatar", 6)
    ]
    
    # Aggiungi i registi
    for director in directors:
        name, biography, category_id = director
        image_url = get_image_url(name)
        
        try:
            if add_director(base_url, token, name, image_url, biography, category_id):
                print(f"Regista '{name}' aggiunto con successo.")
            else:
                print(f"Errore nell'aggiungere il regista '{name}'.")
        except Exception as e:
            print(f"Errore generico per il regista '{name}': {e}")

    # Aggiungi i film
    for movie in movies:
        title, year, page_name, director_id = movie
        image_url = get_image_url(page_name)
        
        try:
            if add_movie(base_url, token, title, year, image_url, director_id):
                print(f"Film '{title}' aggiunto con successo.")
            else:
                print(f"Errore nell'aggiungere il film '{title}'.")
        except Exception as e:
            print(f"Errore generico per il film '{title}': {e}")

if __name__ == "__main__":
    main()
