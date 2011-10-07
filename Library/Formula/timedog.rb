require 'formula'

class Timedog < Formula
  url 'http://timedog.googlecode.com/files/timedog-1.2.zip'
  md5 '0ab0f08df51ce74a10b94dfd4fb3df27'
  homepage 'http://timedog.googlecode.com/'

  def install
    bin.install 'timedog'
  end
end
