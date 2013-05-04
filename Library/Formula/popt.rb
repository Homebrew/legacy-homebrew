require 'formula'

class Popt < Formula
  homepage 'http://rpm5.org'
  url 'http://rpm5.org/files/popt/popt-1.16.tar.gz'
  sha1 'cfe94a15a2404db85858a81ff8de27c8ff3e235e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
