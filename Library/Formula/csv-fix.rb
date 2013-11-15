require 'formula'

class CsvFix < Formula
  homepage 'http://code.google.com/p/csvfix/'
  url 'https://bitbucket.org/neilb/csvfix/get/version-1.5.zip'
  sha1 'ded7d365735547d67150e3bfedcc8ccee3a9271b'

  def install
    system "make lin"
    bin.install 'csvfix/bin/csvfix'
  end
end
