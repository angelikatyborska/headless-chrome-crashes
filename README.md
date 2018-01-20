# Headless Chrome crashes

Headless Chrome running in a Docker container (`ruby:2.5.0`, Debian 9.3 in this case) constantly crashes.

ChromeDriver returns an unexpected by Selenium status 100 which causes gem `selenium/webdriver` to thrown an exception.

No such issues ever occur on my host machine (OS X 10.11.6).

This repo includes a copy of the gem `selenium/webdriver` with a few added `puts` inside `lib/selenium/webdriver/response.rb` for debugging.

## Reproduce

1. Build Docker image
```
docker build -t chrometest .
```

2. Run Docker container
```
docker run -ti --security-opt seccomp:unconfined chrometest bash
```

3. Start simple script that uses Capybara. It might get a few runs to get the exact error with status 100.
```
angelika@8ad017df7b83:~/src$ bundle exec ruby run.rb
```

Expected output:

```
angelika@ddc8d9a1826d:~/src$ bundle exec ruby run.rb
visiting https://instagram.com/kimbramusic
will visit 12 pages
visitng #1 https://www.instagram.com/p/BeI5m_iD5Nm/?taken-by=kimbramusic
visitng #2 https://www.instagram.com/p/BeHl0DDjsit/?taken-by=kimbramusic
visitng #3 https://www.instagram.com/p/BeHZzp3j6oU/?taken-by=kimbramusic
visitng #4 https://www.instagram.com/p/BeHJuofDtW9/?taken-by=kimbramusic
visitng #5 https://www.instagram.com/p/BeGkOPQDkOS/?taken-by=kimbramusic
visitng #6 https://www.instagram.com/p/BeGU5FXDUTT/?taken-by=kimbramusic
visitng #7 https://www.instagram.com/p/BeE0W5MDhJM/?taken-by=kimbramusic
Selenium::WebDriver::Remote::Response.error
status: 100
payload: {"sessionId"=>"c86c4b01f01ad357f3977b619cc01a32", "status"=>100, "value"=>{"message"=>"chrome not reachable\n  (Session info: headless chrome=63.0.3239.132)\n  (Driver info: chromedriver=2.35.528139 (47ead77cb35ad2a9a83248b292151462a66cd881),platform=Linux 4.9.49-moby x86_64)"}}
Traceback (most recent call last):
	27: from run.rb:42:in `<main>'
	26: from run.rb:25:in `run'
	25: from run.rb:25:in `each_with_index'
	24: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/result.rb:40:in `each'
	23: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/result.rb:40:in `each'
	22: from run.rb:31:in `block in run'
	21: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/session.rb:808:in `block (2 levels) in <class:Session>'
	20: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/node/finders.rb:266:in `all'
	19: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/node/base.rb:85:in `synchronize'
	18: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/node/finders.rb:267:in `block in all'
	17: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/queries/selector_query.rb:145:in `resolve_for'
	16: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/node/base.rb:81:in `synchronize'
	15: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/queries/selector_query.rb:147:in `block in resolve_for'
	14: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/node/base.rb:103:in `find_css'
	13: from /usr/local/bundle/gems/capybara-2.17.0/lib/capybara/selenium/driver.rb:84:in `find_css'
	12: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/common/search_context.rb:78:in `find_elements'
	11: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/oss/bridge.rb:557:in `find_elements_by'
	10: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/oss/bridge.rb:579:in `execute'
	 9: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/bridge.rb:164:in `execute'
	 8: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/http/common.rb:59:in `call'
	 7: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/http/default.rb:104:in `request'
	 6: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/http/common.rb:81:in `create_response'
	 5: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/http/common.rb:81:in `new'
	 4: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/response.rb:32:in `initialize'
	 3: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/response.rb:74:in `assert_ok'
	 2: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/remote/response.rb:41:in `error'
	 1: from /home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/common/error.rb:32:in `for_code'
/home/angelika/src/selenium-webdriver-3.8.0/lib/selenium/webdriver/common/error.rb:32:in `fetch': key not found: 100 (KeyError)
```

### Dependency versions

```
angelika@36d2f1a67ecb:~/src$ google-chrome --version
Google Chrome 63.0.3239.132

angelika@36d2f1a67ecb:~/src$ chromedriver --version
ChromeDriver 2.35.528139 (47ead77cb35ad2a9a83248b292151462a66cd881)
```
### Last 100 lines of ChromeDriver's verbose log:

```
angelika@ddc8d9a1826d:~/src$ tail -n 100 chromedriver.log
      "name": "fb_xdm_frame_https",
      "parentId": "(61392D9AF6070C13D30315742BB7A815)",
      "securityOrigin": "https://staticxx.facebook.com",
      "url": "https://staticxx.facebook.com/connect/xd_arbiter/r/lY4eZXm_YWu.js?version=42"
   }
}
[1516467109.448][DEBUG]: DEVTOOLS EVENT Runtime.executionContextCreated {
   "context": {
      "auxData": {
         "frameId": "(F436CA0F775FE55945C98D488B00958C)",
         "isDefault": true
      },
      "id": 3,
      "name": "",
      "origin": "https://staticxx.facebook.com"
   }
}
[1516467109.463][DEBUG]: DEVTOOLS EVENT Page.lifecycleEvent {
   "frameId": "(F436CA0F775FE55945C98D488B00958C)",
   "name": "load",
   "timestamp": 6676.936202
}
[1516467109.463][DEBUG]: DEVTOOLS EVENT Page.frameStoppedLoading {
   "frameId": "(F436CA0F775FE55945C98D488B00958C)"
}
[1516467109.464][DEBUG]: DEVTOOLS EVENT Page.lifecycleEvent {
   "frameId": "(F436CA0F775FE55945C98D488B00958C)",
   "name": "DOMContentLoaded",
   "timestamp": 6676.937354
}
[1516467109.464][DEBUG]: DEVTOOLS RESPONSE Runtime.evaluate (id=23) {
   "result": {
      "description": "1",
      "type": "number",
      "value": 1
   }
}
[1516467109.603][SEVERE]: Unable to receive message from renderer
[1516467109.605][INFO]: Done waiting for pending navigations. Status: disconnected: Unable to receive message from renderer
[1516467109.605][DEBUG]: DevTools request: http://localhost:12833/json
[1516467109.606][DEBUG]: DevTools request failed
[1516467109.607][INFO]: RESPONSE Navigate
[1516467109.611][INFO]: COMMAND FindElements {
   "using": "css selector",
   "value": "article div div div div img"
}
[1516467109.611][INFO]: resolved localhost to ["127.0.0.1","::1"]
[1516467109.611][DEBUG]: failed to connect to localhost (error -108)
[1516467109.611][DEBUG]: DevTools request: http://localhost:12833/json
[1516467109.612][DEBUG]: DevTools request failed
[1516467109.614][INFO]: RESPONSE FindElements chrome not reachable
  (Session info: headless chrome=63.0.3239.132)
[1516467109.619][INFO]: COMMAND Quit {

}
[1516467109.620][INFO]: RESPONSE Quit
[1516467109.620][DEBUG]: Log type 'driver' lost 1 entries on destruction
[1516467109.620][DEBUG]: Log type 'browser' lost 0 entries on destruction
[1516467109.950][INFO]: COMMAND Quit {

}
[1516467110.001][INFO]: RESPONSE Quit
[1516467110.001][DEBUG]: Log type 'driver' lost 0 entries on destruction
[1516467110.001][DEBUG]: Log type 'browser' lost 0 entries on destruction
[1516467110.107][INFO]: COMMAND Quit {

}
[1516467110.158][INFO]: RESPONSE Quit
[1516467110.158][DEBUG]: Log type 'driver' lost 0 entries on destruction
[1516467110.158][DEBUG]: Log type 'browser' lost 0 entries on destruction
[1516467109.796][INFO]: COMMAND Quit {

}
[1516467109.846][INFO]: RESPONSE Quit
[1516467109.846][DEBUG]: Log type 'driver' lost 0 entries on destruction
[1516467109.846][DEBUG]: Log type 'browser' lost 0 entries on destruction
[1516467109.628][INFO]: COMMAND Quit {

}
[1516467109.680][INFO]: RESPONSE Quit
[1516467109.680][DEBUG]: Log type 'driver' lost 0 entries on destruction
[1516467109.680][DEBUG]: Log type 'browser' lost 0 entries on destruction
[1516467110.263][INFO]: COMMAND Quit {

}
[1516467110.315][INFO]: RESPONSE Quit
[1516467110.315][DEBUG]: Log type 'driver' lost 0 entries on destruction
[1516467110.315][DEBUG]: Log type 'browser' lost 0 entries on destruction
[1516467110.420][INFO]: COMMAND Quit {

}
[1516467110.471][INFO]: RESPONSE Quit
[1516467110.472][DEBUG]: Log type 'driver' lost 0 entries on destruction
[1516467110.472][DEBUG]: Log type 'browser' lost 0 entries on destruction
[1516467110.478][INFO]: COMMAND Quit {

}
[1516467110.529][INFO]: RESPONSE Quit
[1516467110.529][DEBUG]: Log type 'driver' lost 0 entries on destruction
[1516467110.529][DEBUG]: Log type 'browser' lost 0 entries on destruction
```
