require 'formula'

class Boxes < Formula
  homepage 'http://boxes.thomasjensen.com/'
  url 'http://boxes.thomasjensen.com/download/boxes-1.1.1.src.tar.gz'
  head 'https://github.com/ascii-boxes/boxes.git'
  sha1 '9b09f8c59276a3978ecaf985029b8459aa69e9c1'

  def install
    ENV.m32

    # distro uses /usr/share/boxes change to prefix
    system "make",
      "GLOBALCONF=#{share}/boxes-config",
      "CC=#{ENV.cc}",
      # Force 32 bit compile
      # These flags are only (as of 1.1.1) supported on HEAD
      "CFLAGS_ADDTL=-m32",
      "LDFLAGS_ADDTL=-m32"

    bin.install 'src/boxes'
    man1.install 'doc/boxes.1'
    share.install 'boxes-config'
  end
end
