class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "http://fribidi.org/"
  url "http://fribidi.org/download/fribidi-0.19.7.tar.bz2"
  sha256 "08222a6212bbc2276a2d55c3bf370109ae4a35b689acbc66571ad2a670595a8e"

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
    system "make", "install"
  end
end
