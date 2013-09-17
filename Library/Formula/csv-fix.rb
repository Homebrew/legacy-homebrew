require 'formula'

class CsvFix < Formula
  homepage 'http://code.google.com/p/csvfix/'
  url 'https://csvfix.googlecode.com/archive/version-1.3.zip'
  version '1.3'
  sha1 '76f959c29944fa915a37a3d8cf478149ebd83036'

  def install
    system "make lin"
    bin.install 'csvfix/bin/csvfix'
  end
end
