require "formula"

class Odo < Formula
  homepage "https://github.com/atomicobject/odo"
  url "https://github.com/atomicobject/odo/archive/v0.1.0.tar.gz"
  sha1 "36cbe1b626612e0bbdf719640801d84b8234d7af"

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
