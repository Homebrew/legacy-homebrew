class Odo < Formula
  desc "Atomic odometer for the command-line"
  homepage "https://github.com/atomicobject/odo"
  url "https://github.com/atomicobject/odo/archive/v0.2.2.tar.gz"
  sha256 "52133a6b92510d27dfe80c7e9f333b90af43d12f7ea0cf00718aee8a85824df5"

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
