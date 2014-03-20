require 'formula'

class Feh < Formula
  homepage 'http://feh.finalrewind.org/'
  url 'http://feh.finalrewind.org/feh-2.10.tar.bz2'
  sha1 '38b472f2a3222e287269a0719c7ead383f1cb8a5'

  depends_on :x11
  depends_on 'giblib' => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
