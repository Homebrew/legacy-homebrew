require 'formula'

class Feh < Formula
  url 'http://feh.finalrewind.org/feh-2.2.tar.bz2'
  homepage 'http://feh.finalrewind.org/'
  md5 '7dee285e8dd34f69058b0977283b3a8a'

  depends_on 'giblib' => :build
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
