require 'formula'

class Serf < Formula
  homepage 'http://code.google.com/p/serf/'
  url 'http://serf.googlecode.com/files/serf-0.7.2.tar.bz2'
  md5 '66ed12163b14b704888e628ee38e9581'

  def install
    system "./configure", "--disable-debug", 
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
