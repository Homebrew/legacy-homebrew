require 'formula'

class Feh < Formula
  homepage 'http://feh.finalrewind.org/'
  url 'http://feh.finalrewind.org/feh-2.9.2.tar.bz2'
  sha1 '4d7d183491f916c8f1db668065f986f4a845503e'

  depends_on :x11
  depends_on 'giblib' => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
