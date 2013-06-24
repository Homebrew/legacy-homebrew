require 'formula'

class Feh < Formula
  homepage 'http://feh.finalrewind.org/'
  url 'http://feh.finalrewind.org/feh-2.9.3.tar.bz2'
  sha1 '6e93c9bbc339d36002ead189d0a94880f58876bd'

  depends_on :x11
  depends_on 'giblib' => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
