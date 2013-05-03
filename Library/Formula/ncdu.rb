require 'formula'

class Ncdu < Formula
  homepage 'http://dev.yorhel.nl/ncdu'
  url 'http://dev.yorhel.nl/download/ncdu-1.9.tar.gz'
  sha1 '27cb5464b192db8ffdf0a894fe51d29985348eb0'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
