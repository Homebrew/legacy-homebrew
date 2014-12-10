require 'formula'

class Chromedriver < Formula
  homepage 'https://sites.google.com/a/chromium.org/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.12/chromedriver_mac32.zip'
  sha256 'f93464dd4e57f7d59601e9ab92ad0770493f9ea00b69ddba8da3886c35852d4b'
  version '2.12'

  def install
    bin.install 'chromedriver'
  end
end
