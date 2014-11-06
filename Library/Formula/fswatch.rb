require "formula"

class Fswatch < Formula
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.4.5.2/fswatch-1.4.5.2.tar.gz"
  sha1 "1905b126a8e0610e2adb255b64d8415d0e844a6a"

  bottle do
    sha1 "b85cf3971c74b81faa94e531b3fb454430717ebf" => :yosemite
    sha1 "9c5fa979651205ebb02d8029bf24a9900897f7ab" => :mavericks
    sha1 "572a79a79e3049420f62442787a2d7b6984655a2" => :mountain_lion
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
