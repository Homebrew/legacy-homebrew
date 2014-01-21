require "formula"

class Rig < Formula
  homepage "http://packages.debian.org/wheezy/rig"
  url "http://ftp.de.debian.org/debian/pool/main/r/rig/rig_1.11.orig.tar.gz"
  sha1 "53a26676c35ba0c1112e1906deebb33a41dd5e95"

  def install
    system "make"
    bin.install 'rig'
    (share/'rig').install 'data' 
  end

  test do
    system "rig"
  end
end
