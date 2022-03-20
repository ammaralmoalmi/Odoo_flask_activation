FROM python:3.10.0-alpine3.15
WORKDIR /app
COPY source source
# RUN pwd
COPY requirements.txt .

# RUN pip install click==8.0.3
# RUN pip install colorama==0.4.4
# RUN pip install Flask==2.0.2
# RUN pip install itsdangerous==2.0.1
# RUN pip install Jinja2==3.0.3
# RUN pip install MarkupSafe==2.0.1
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt
RUN mkdir -p data
VOLUME /app/data 

# ADD source /app

EXPOSE 5005
# HEALTHCHECK --interval=120s --timeout=240s --start-period=60s --retries=5 \
#             CMD curl -f http://localhost:5000/health || exit 1
ENTRYPOINT ["python","./source/app.py"]
