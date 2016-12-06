require 'formula'

class Libmetalink < Formula
  url 'https://launchpad.net/libmetalink/trunk/0.0.3/+download/libmetalink-0.0.3.tar.bz2'
  homepage 'https://launchpad.net/libmetalink/'
  md5 'de9dbf893e3b5853c5eedd699606e570'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    unless File.exist?("#{HOMEBREW_PREFIX}/lib/libmetalink.a")
      opoo "Failed to create libmetalink.a"
    end
  end
end
