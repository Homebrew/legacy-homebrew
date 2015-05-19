require "formula"

class P0f < Formula
  desc "Versatile passive OS fingerprinting, masquerade detection tool"
  homepage "http://lcamtuf.coredump.cx/p0f3/"
  url "http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.07b.tgz"
  sha1 "ae2c4fbcddf2a5ced33abd81992405b93207e7c8"

  bottle do
    cellar :any
    sha1 "eceeb864d78eb22bd5808690f1ce818f196b0c9b" => :mavericks
    sha1 "261610220600d44a55fd31c2ca68849cc9e4db4f" => :mountain_lion
    sha1 "47e0e995504b87ea470c5ebb6583bd67cd447f95" => :lion
  end

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install "p0f"
    (etc+"p0f").install "p0f.fp"
  end

  test do
    system "#{sbin}/p0f", "-r", test_fixtures("test.pcap")
  end
end
