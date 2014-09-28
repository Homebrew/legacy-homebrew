require "formula"

class Fswatch < Formula
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.4.5/fswatch-1.4.5.zip"
  sha1 "3cd9b293713a855a13cbcbd6393d2444bcfdb65b"

  bottle do
    sha1 "b61f31c29361c56629d67d0cdd8ff5c90b1c307d" => :mavericks
    sha1 "406c88e7119ed88cf27cabe4fbc1adf1d7def61e" => :mountain_lion
    sha1 "f36a3d2e25ad560d44458c2bef5a45777a2d72b3" => :lion
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
