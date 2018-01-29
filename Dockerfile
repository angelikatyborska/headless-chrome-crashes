FROM elixir:1.6

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update
RUN apt-get install -y google-chrome-stable zip unzip

# Install ChromeDriver
RUN wget -N http://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip -P ~/
RUN unzip ~/chromedriver_linux64.zip -d ~/
RUN rm ~/chromedriver_linux64.zip
RUN mv -f ~/chromedriver /usr/local/bin/chromedriver
RUN chown root:root /usr/local/bin/chromedriver
RUN chmod 0755 /usr/local/bin/chromedriver

RUN useradd angelika
WORKDIR /home/angelika/src

COPY . /home/angelika/src

RUN chown -R angelika:angelika /home/angelika/

USER angelika
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile
