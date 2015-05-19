require 'formula'

class Cityhash < Formula
  desc "Hash functions for strings"
  homepage 'https://code.google.com/p/cityhash/'
  url 'https://cityhash.googlecode.com/files/cityhash-1.1.1.tar.gz'
  sha1 '74342b9161bc762e4c14627a9281bef2d3cb5eed'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
