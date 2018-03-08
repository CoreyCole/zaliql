FROM python:3.6.4-onbuild
# "-onbuild" automatically installs the requirements.txt file

EXPOSE 5000
EXPOSE 5433
 
WORKDIR /backend
RUN cd /backend

# gunicorn python server listening on port 5000
# using 1 worker process
# automatically reloads on python file changes
CMD ["gunicorn", "--workers=1", "app:APP", "--bind", "0.0.0.0:5000", "--reload"]
