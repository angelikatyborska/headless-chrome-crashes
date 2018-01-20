require 'capybara'
require "selenium/webdriver"

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chrome_options: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities,
    driver_opts: { verbose: true, log_path: './chromedriver.log' }
end

Capybara.default_driver = :headless_chrome

def run
  session = Capybara::Session.new(:headless_chrome)

  puts "visiting https://instagram.com/kimbramusic"
  session.visit "https://instagram.com/kimbramusic"

  links = session.find_all('main article div div a')
  puts "will visit #{links.count} pages"
  links.each_with_index do |link, index|
    session2 = Capybara::Session.new(:headless_chrome)

    puts "visitng ##{index + 1} #{link['href']}"
    session2.visit link['href']

    imgs = session2.find_all('article div div div div img')

    if imgs[0]
      imgs[0]['src']
    else
      videos = session2.find_all('article div div div div video')
      videos[0]['poster']
    end
  end
end

run
