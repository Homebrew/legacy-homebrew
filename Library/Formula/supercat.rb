require 'formula'

class Supercat < Formula
  homepage 'http://supercat.nosredna.net'
  url 'http://supercat.nosredna.net/supercat-0.5.5.tar.gz'
  sha1 'e7d1f0f5b4bb50171fd6c7d2bc3e28492ff54848'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-system-directory=#{prefix}/etc"
    system "make install"
  end
end
