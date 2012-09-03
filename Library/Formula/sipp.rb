require 'formula'

class Sipp < Formula
  url 'http://downloads.sourceforge.net/project/sipp/sipp/3.2/sipp.svn.tar.gz'
  homepage 'http://sipp.sourceforge.net/'
  sha1 'cef9e061b3223b228ae403f897edc192b3ce2ce7'
  version '3.2'

  def install
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end
end
