require "formula"

class Hatari < Formula
  homepage "http://hatari.tuxfamily.org"
  head "http://hg.tuxfamily.org/mercurialroot/hatari/hatari", :using => :hg, :branch => "default"
  url "http://download.tuxfamily.org/hatari/1.8.0/hatari-1.8.0.tar.bz2"
  sha1 "08d950c3156c764b87ac0ae03c4f350febff9567"

  depends_on :x11
  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "sdl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-osx-bundle"
    system "make install"
  end
end
