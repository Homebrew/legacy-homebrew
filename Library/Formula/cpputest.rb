require "formula"

class Cpputest < Formula
  homepage "http://www.cpputest.org/"
  url "https://github.com/cpputest/cpputest/archive/v3.6.tar.gz"
  sha1 "308a4200adfb86182251d435e09f42360d9ed8ea"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
