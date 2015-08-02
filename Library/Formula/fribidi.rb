require 'formula'

class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage 'http://fribidi.org/'
  url 'http://fribidi.org/download/fribidi-0.19.6.tar.bz2'
  sha1 '5a6ff82fdee31d27053c39e03223666ac1cb7a6a'

  bottle do
    cellar :any
    revision 1
    sha1 "a8953ae123d463733cd73fd28972955e886a5821" => :yosemite
    sha1 "cc92ce67750c60add21cc8cd4eebdc5b1057d01b" => :mavericks
    sha1 "f1d37cf53fd17aa8e6c09aa7b8045f67de82f19d" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
