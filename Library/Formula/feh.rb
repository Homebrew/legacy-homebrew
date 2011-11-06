require 'formula'

class Feh < Formula
  url 'http://feh.finalrewind.org/feh-1.16.tar.bz2'
  homepage 'http://freshmeat.net/projects/feh'
  md5 'd8583e8dde2f383dc9a8dfc28bf6b348'

  depends_on 'giblib' => :build

  def install
    ENV.x11

    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
