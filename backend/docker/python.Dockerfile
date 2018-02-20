FROM python:3.6.4-onbuild

EXPOSE 5000
EXPOSE 5433
 
WORKDIR /backend

CMD ["python", "-u", "/backend/app.py"]
