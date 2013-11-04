require 'formula'

class Chromedriver < Formula
  homepage 'http://code.google.com/p/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.5/chromedriver_mac32.zip'
  sha1 '2eee598714762e49051460f769be0053e15c6c3e'
  version '2.5'

  def install
    bin.install 'chromedriver'
  end
end
