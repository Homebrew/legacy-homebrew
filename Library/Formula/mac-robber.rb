require 'formula'

class MacRobber < Formula
  homepage 'http://www.sleuthkit.org/mac-robber/'
  url 'https://downloads.sourceforge.net/project/mac-robber/mac-robber/1.02/mac-robber-1.02.tar.gz'
  sha1 'c50c823ac14ac8e78e79e0965134b028757e4519'

  def install
    system "make", "CC=#{ENV.cc}", "GCC_OPT=#{ENV.cflags}"
    bin.install 'mac-robber'
  end
end
