# Headless Chrome crashes

## Reproduce

1. Build Docker image
```
docker build -t chrometest .
```

2. Run Docker container
```
docker run -ti chrometest bash
```

3. Start simple script that uses Wallaby. It might get a few runs to get the exact error with status 100.
```
angelika@8ad017df7b83:~/src$ mix run run.exs
```

Expected output:

```
angelika@ddc8d9a1826d:~/src$ mix run run.exs
"visiting https://instagram.com/kimbramusic"
"will visit 12 pages"
"visitng https://www.instagram.com/p/BeijUKDDHBF/?taken-by=kimbramusic"
"visitng https://www.instagram.com/p/BehbRCbDszx/?taken-by=kimbramusic"
"visitng https://www.instagram.com/p/BehaNpCDnNW/?taken-by=kimbramusic"
"visitng https://www.instagram.com/p/BeghSGzjxAl/?taken-by=kimbramusic"
"visitng https://www.instagram.com/p/BeeG-C4D4-j/?taken-by=kimbramusic"
"visitng https://www.instagram.com/p/BedfaEADEsO/?taken-by=kimbramusic"
[1517250510.669][SEVERE]: Unable to receive message from renderer
[1517250510.685][WARNING]: Unable to evaluate script: disconnected: not connected to DevTools
** (FunctionClauseError) no function clause matching in Wallaby.Experimental.Selenium.WebdriverClient.cast_as_element/2    
    
    The following arguments were given to Wallaby.Experimental.Selenium.WebdriverClient.cast_as_element/2:
    
        # 1
        %Wallaby.Session{driver: Wallaby.Experimental.Chrome, id: "07c84eb74f753c43f1aa67e8e585c26c", screenshots: [], server: Wallaby.Experimental.Chrome.Chromedriver, session_url: "http://localhost:58348/session/07c84eb74f753c43f1aa67e8e585c26c", url: "http://localhost:58348/session/07c84eb74f753c43f1aa67e8e585c26c"}
    
        # 2
        {"message", "chrome not reachable\n  (Session info: headless chrome=64.0.3282.119)\n  (Driver info: chromedriver=2.35.528139 (47ead77cb35ad2a9a83248b292151462a66cd881),platform=Linux 4.4.41-moby x86_64)"}
    
    Attempted function clauses (showing 1 out of 1):
    
        defp cast_as_element(parent, %{"ELEMENT" => id})
    
    (wallaby) lib/wallaby/experimental/selenium/webdriver_client.ex:359: Wallaby.Experimental.Selenium.WebdriverClient.cast_as_element/2
    (elixir) lib/enum.ex:1298: anonymous fn/3 in Enum.map/2
    (stdlib) lists.erl:1263: :lists.foldl/3
    (elixir) lib/enum.ex:1915: Enum.map/2
    (wallaby) lib/wallaby/experimental/selenium/webdriver_client.ex:36: Wallaby.Experimental.Selenium.WebdriverClient.find_elements/2
    (wallaby) lib/wallaby/driver/log_checker.ex:6: Wallaby.Driver.LogChecker.check_logs!/2
    (wallaby) lib/wallaby/browser.ex:919: anonymous fn/3 in Wallaby.Browser.execute_query/2
    (wallaby) lib/wallaby/browser.ex:142: Wallaby.Browser.retry/2
```
