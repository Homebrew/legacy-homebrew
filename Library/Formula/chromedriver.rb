require 'formula'

class Chromedriver < Formula
  homepage 'https://sites.google.com/a/chromium.org/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.14/chromedriver_mac32.zip'
  sha256 '33ee96ea17b00dd8e14e15ca6fe1b1fd4ae7a71f86d8785e562e88d839299d2e'
  version '2.14'

  def install
    bin.install 'chromedriver'
  end
end
