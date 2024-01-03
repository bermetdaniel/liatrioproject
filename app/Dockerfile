FROM --platform=linux/amd64 python:3.9-alpine 

WORKDIR /app

COPY requirements.txt .
RUN apk add --no-cache gcc musl-dev libffi-dev
RUN pip install -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD [ "python", "app.py" ]