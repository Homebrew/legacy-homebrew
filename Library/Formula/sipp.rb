require 'formula'

class Sipp < Formula
  homepage 'http://sipp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/sipp/sipp/3.2/sipp.svn.tar.gz'
  sha1 'cef9e061b3223b228ae403f897edc192b3ce2ce7'

  def install
    system "make", "DESTDIR=#{prefix}"
    bin.install "sipp"
  end
end
