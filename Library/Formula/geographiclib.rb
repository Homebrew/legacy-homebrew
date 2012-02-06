require 'formula'

class Geographiclib < Formula
  url 'http://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.17.tar.gz'
  homepage 'http://geographiclib.sourceforge.net/'
  md5 '56b3b684e5f34268d155d70c964c99d2'


  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
