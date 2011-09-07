require 'formula'

class Chromedriver < Formula
  url 'http://chromium.googlecode.com/files/chromedriver_mac_14.0.836.0.zip'
  homepage 'http://code.google.com/p/selenium/wiki/ChromeDriver'
  sha1 '2b292bb47e26286fc714c3b9a74904800a6acc97'

  def install
    bin.install 'chromedriver'
  end
end
