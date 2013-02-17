require 'formula'

class Cityhash < Formula
  homepage 'http://code.google.com/p/cityhash/'
  url 'http://cityhash.googlecode.com/files/cityhash-1.0.3.tar.gz'
  sha1 '855c1aa88267fb30a8a9ecd849bb2838638e2248'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
