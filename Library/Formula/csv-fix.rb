require 'formula'

class CsvFix < Formula
  homepage 'http://code.google.com/p/csvfix/'
  url 'https://csvfix.googlecode.com/archive/version-1.3.zip'
  version '1.3'
  sha1 '8a0303e5c43062cf348e992c52058bd125cb16a8'

  def install
    system "make lin"
    bin.install 'csvfix/bin/csvfix'
  end
end
