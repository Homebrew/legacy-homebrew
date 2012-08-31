require 'formula'

class Feh < Formula
  homepage 'http://feh.finalrewind.org/'
  url 'http://feh.finalrewind.org/feh-2.5.tar.bz2'
  sha1 'd1bf7fa8ec6b5d1ce16c291edf38d45de01f252d'

  depends_on 'giblib' => :build
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
