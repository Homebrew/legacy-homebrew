require 'formula'

class Feh < Formula
  homepage 'http://feh.finalrewind.org/'
  url 'http://feh.finalrewind.org/feh-2.7.tar.bz2'
  sha1 '25c3cf8af2d30b9cc176b36f2a78344ba9ae18f1'

  depends_on :x11
  depends_on 'giblib' => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
