require "formula"

class Fswatch < Formula
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.4.5/fswatch-1.4.5.zip"
  sha1 "3cd9b293713a855a13cbcbd6393d2444bcfdb65b"

  bottle do
    sha1 "f2ac892185e46b924137ee43a3553701c6ae56f4" => :mavericks
    sha1 "51173f4ccbd1cb65fd7dfe87b42aab12cbed7630" => :mountain_lion
    sha1 "3e673400d51c8b622d6c21e2965078936cd28bcf" => :lion
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
