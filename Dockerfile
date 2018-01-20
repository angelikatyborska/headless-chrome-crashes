FROM ruby:2.5.0

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update
RUN apt-get install -y google-chrome-stable

RUN adduser angelika
WORKDIR /home/angelika/src

COPY selenium-webdriver-3.8.0 /home/angelika/src/selenium-webdriver-3.8.0
COPY Gemfile /home/angelika/src/
COPY Gemfile.lock /home/angelika/src/

RUN bundle install
COPY . /home/angelika/src

RUN chown -R angelika:angelika /home/angelika/

USER angelika
