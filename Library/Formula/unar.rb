require 'formula'

class Unar < Formula
  url 'http://theunarchiver.googlecode.com/files/unar0.99.zip'
  homepage 'http://code.google.com/p/theunarchiver/'
  md5 '278c10061a881f0bd36e818d7635b151'

  def install
    bin.install Dir['*']
  end
end
