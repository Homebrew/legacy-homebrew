require 'formula'

class CsvFix < Formula
  homepage 'http://code.google.com/p/csvfix/'
  url 'https://bitbucket.org/neilb/csvfix/get/version-1.3.zip'
  sha1 '9d8c4c38abf4be722eb6e3fc967fd2eeb3bd2299'

  def install
    system "make lin"
    bin.install 'csvfix/bin/csvfix'
  end
end
