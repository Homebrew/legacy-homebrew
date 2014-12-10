require "formula"

class Orpie < Formula
  homepage "http://pessimization.com/software/orpie/"
  url "http://pessimization.com/software/orpie/orpie-1.5.2.tar.gz"
  sha1 "9786df20fb272fd36f87868bed04cab504602282"

  depends_on "gsl"
  depends_on "objective-caml"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
