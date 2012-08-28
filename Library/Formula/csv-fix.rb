require 'formula'

class CsvFix < Formula
  homepage 'http://code.google.com/p/csvfix/'
  url 'https://bitbucket.org/neilb/csvfix/get/6c861665bf41.tar.bz2'
  version '1.3'
  sha1 'c69112be21f08d3f424bba0d1ee3be7376b5e7f6'

  def install
    inreplace 'csvfix/Makefile', 'g++', 'c++'
    inreplace 'alib/Makefile', 'g++', 'c++'
    system "make lin"
    bin.install 'csvfix/bin/csvfix'
  end
end
