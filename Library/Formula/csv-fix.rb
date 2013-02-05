require 'formula'

class CsvFix < Formula
  homepage 'http://code.google.com/p/csvfix/'
  url 'http://csvfix.googlecode.com/files/csvfix_src_120.zip'
  version '1.20'
  sha1 'ec0b6d491429d908a9208d6e474591f30dec654c'

  def install
    system "make lin"
    bin.install 'csvfix/bin/csvfix'
  end
end
