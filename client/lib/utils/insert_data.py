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

def get_image_url(page_name):
    search_url = f"https://en.wikipedia.org/wiki/{page_name.replace(' ', '_')}"
    response = requests.get(search_url)
    
    if response.status_code == 200:
        soup = BeautifulSoup(response.content, 'html.parser')
        infobox = soup.find('table', class_='infobox')
        if infobox:
            image = infobox.find('img')
            if image:
                image_url = 'https:' + image['src']
                return image_url
    return None  

def add_movie(base_url, title, year, image_url, director_id):
    endpoint = '/movies'
    url = f'{base_url}{endpoint}'

    headers = {'Content-Type': 'application/json'}
    payload = {
        'title': title,
        'year': year,
        'image_url': image_url,
        'director_id': director_id,
    }

    response = requests.post(
        url,
        headers=headers,
        data=json.dumps(payload),
    )

    return response.status_code == 200

def add_director(base_url, name, image_url, biography, category_id):
    endpoint = '/directors'
    url = f'{base_url}{endpoint}'

    headers = {'Content-Type': 'application/json'}
    payload = {
        'name': name,
        'image_url': image_url,
        'biography': biography,
        'category': category_id
    }

    response = requests.post(
        url,
        headers=headers,
        data=json.dumps(payload),
    )

    return response.status_code == 200

def main():
    base_url = 'http://172.18.0.3:5000'
    
    directors = [
        ("Christopher Nolan", biographies["Christopher Nolan"], categories['Thriller'].id),
        ("Alfred Hitchcock", biographies["Alfred Hitchcock"], categories['Thriller'].id),
        ("Steven Spielberg", biographies["Steven Spielberg"], categories['Avventura'].id),
        ("Guillermo del Toro", biographies["Guillermo del Toro"], categories['Horror'].id),
        ("Quentin Tarantino", biographies["Quentin Tarantino"], categories['Thriller'].id),
        ("James Cameron", biographies["James Cameron"], categories['Avventura'].id)
    ]

    movies = [
        ("Inception", 2010, "Inception", 1),
        ("Psycho", 1960, "Psycho", 2),
        ("Jurassic Park", 1993, "Jurassic_Park", 3),
        ("The Shape of Water", 2017, "The_Shape_of_Water", 4),
        ("Pulp Fiction", 1994, "Pulp_Fiction", 5),
        ("Avatar", 2009, "Avatar", 6)
    ]
    
    for director in directors:
        name, biography, category_id = director
        image_url = get_image_url(name)
        
        if add_director(base_url, name, image_url, biography, category_id):
            print(f"Regista '{name}' aggiunto con successo.")
        else:
            print(f"Errore nell'aggiungere il regista '{name}'.")
    
    

    for movie in movies:
        title, year, page_name, director_id = movie
        image_url = get_image_url(page_name)
        
        if add_movie(base_url, title, year, image_url, director_id):
            print(f"Film '{title}' aggiunto con successo.")
        else:
            print(f"Errore nell'aggiungere il film '{title}'.")


if __name__ == "__main__":
    main()
