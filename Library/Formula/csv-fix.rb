require 'formula'

class CsvFix < Formula
  url 'http://csvfix.googlecode.com/files/csvfix_src_110a.zip'
  homepage 'http://code.google.com/p/csvfix/'
  version '1.1a'
  sha1 'd579c6223a9570e207b9e9b9eccb7f621916e673'

  def install
    system "make lin"
    bin.install 'csvfix/bin/csvfix'
  end
end
