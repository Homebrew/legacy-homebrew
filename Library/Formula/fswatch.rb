require "formula"

class Fswatch < Formula
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.4.4/fswatch-1.4.4.zip"
  sha1 "3f215a5ed50f4c9863ff5c0350e564e77dc18654"

  bottle do
    sha1 "886050fa4d4d137a376ff50269b1ebc667f39bec" => :mavericks
    sha1 "64c60c0e7a8f86e4ed9b225b1533be6b6f0b858d" => :mountain_lion
    sha1 "4d70a14e0f68a3134b03952e287aab76710c96f9" => :lion
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
