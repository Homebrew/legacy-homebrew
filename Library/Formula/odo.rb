require "formula"

class Odo < Formula
  homepage "https://github.com/atomicobject/odo"
  url "https://github.com/atomicobject/odo/archive/v0.2.2.tar.gz"
  sha1 "2024e3afeee76eb9f4f7e798ac986f4ce8b489d6"

  bottle do
    cellar :any
    sha1 "0b19e2bc1308ef7bc9640cf8140ce60823933e07" => :yosemite
    sha1 "d503b71664f5bb01be9d96d31ee6a7f6f6d4324b" => :mavericks
    sha1 "42ec73e761493d9887c41abe5df3fe6de0f3741c" => :mountain_lion
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
