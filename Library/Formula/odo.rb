require "formula"

class Odo < Formula
  homepage "https://github.com/atomicobject/odo"
  url "https://github.com/atomicobject/odo/archive/v0.2.2.tar.gz"
  sha1 "2024e3afeee76eb9f4f7e798ac986f4ce8b489d6"

  bottle do
    cellar :any
    sha1 "32b8859f631257fe07822f8b1874587b307c2e5e" => :yosemite
    sha1 "c144e0e0b62432b4ee22f28297028b3f2e9d7499" => :mavericks
    sha1 "545135a2f69e20036ff34dd7b0f44493c8e74c40" => :mountain_lion
  end

  def install
    system "make"
    man1.mkpath
    bin.mkpath
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "odo", "testlog"
  end
end
