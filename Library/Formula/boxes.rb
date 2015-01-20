require 'formula'

class Boxes < Formula
  homepage 'http://boxes.thomasjensen.com/'
  url 'https://github.com/ascii-boxes/boxes/archive/v1.1.2.tar.gz'
  head 'https://github.com/ascii-boxes/boxes.git'
  sha1 'dcd466efe1878e4ee612a5eee8f4caf8baac7f31'

  bottle do
    sha1 "6ace9ba08d5d1b528015598c5ed44b86c35c15f3" => :yosemite
    sha1 "132294a712de399d24b7ebdc55ea611a1f9b0fe6" => :mavericks
    sha1 "3078e1f6738312c3bc7b3c4a38043b037cc01fa0" => :mountain_lion
  end

  def install
    ENV.m32

    # distro uses /usr/share/boxes change to prefix
    system "make",
      "GLOBALCONF=#{share}/boxes-config",
      "CC=#{ENV.cc}",
      # Force 32 bit compile
      "CFLAGS_ADDTL=-m32",
      "LDFLAGS_ADDTL=-m32"

    bin.install 'src/boxes'
    man1.install 'doc/boxes.1'
    share.install 'boxes-config'
  end
end
