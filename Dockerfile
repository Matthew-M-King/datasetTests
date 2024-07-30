FROM python:3.11-bookworm

RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub 
RUN apt-key add linux_signing_key.pub
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
# update and install softwares
RUN apt-get -yqq update && apt-get install -yqq \
    xvfb \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxkbcommon0 \
    libxrandr2 \
    unixodbc \
    odbc-postgresql \
    xdg-utils \
    wget \
    ntpdate \
    gettext

RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    ln -s /usr/bin/google-chrome-stable /usr/bin/chrome

#install chrome-driver
RUN CHROMEDRIVER_VERSION=`curl -sS https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE` && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip https://storage.googleapis.com/chrome-for-testing-public/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver-linux64/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

WORKDIR /home/test
VOLUME /home/test/output
# install dependencies
COPY requirements.txt ./requirements.txt
RUN pip install --upgrade --upgrade-strategy eager --requirement requirements.txt

# copy the project
COPY . .
