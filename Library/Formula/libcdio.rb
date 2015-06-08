require "formula"

class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "http://www.gnu.org/software/libcdio/"
  url "http://ftpmirror.gnu.org/libcdio/libcdio-0.93.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libcdio/libcdio-0.93.tar.gz"
  sha1 "bc3f599b0b77d8d186c0afc66495f721747c5293"

  bottle do
    cellar :any
    sha1 "238264203ea7edf8bbceff7b96769b7d5375e44d" => :yosemite
    sha1 "8ae5dd507c22a07fc517073878dfbcba44dab38f" => :mavericks
    sha1 "e85ebcfa037fe2d2615d74cf8a71ffca11a76901" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
