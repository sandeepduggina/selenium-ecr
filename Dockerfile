# Linux
#FROM selenium/standalone-chrome:4.16.1-20231219

# MacOS M1
FROM seleniarm/standalone-chromium
# Use root to install libraries.
USER root

WORKDIR /app
COPY requirements.txt requirements.txt

# Give permissions to seluser for the folders needed.
RUN chown -R seluser:seluser /app && \
    chown -R seluser:seluser /tmp


RUN apt-get update -yqq && \
    apt-get -yqq install python3.11-venv python3-pip && \
    python3.11 -m venv /venv && \
    /venv/bin/pip install -r requirements.txt && \
    rm -rf /tmp/*

# Update PATH so the libraries installed can be accessed directly.
ENV PATH="/venv/bin:$PATH"

COPY . /app

# Change back to the default seluser.
USER seluser

EXPOSE 4444

# docker run --rm -it -e VNDLY_PASSWORD='vndly_password' -e WORKER_TRACKER_ID='249' vndly-chrome-selenium:latest python auth.py
