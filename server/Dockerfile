FROM python:3.12-alpine

COPY db /srv/db
COPY utils /srv/utils
COPY main.py /srv/main.py
COPY requirements.txt /srv/requirements.txt

WORKDIR /srv

RUN apk update
RUN apk add pkgconfig
RUN apk add --no-cache gcc musl-dev mariadb-connector-c-dev
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "main.py"]
