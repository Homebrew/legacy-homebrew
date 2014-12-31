require 'formula'

class Boxes < Formula
  homepage 'http://boxes.thomasjensen.com/'
  url 'https://github.com/ascii-boxes/boxes/archive/v1.1.1.tar.gz'
  head 'https://github.com/ascii-boxes/boxes.git'
  sha1 'fff0d7636c50a4ffa88389981a3d32e8d7a83b39'

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
