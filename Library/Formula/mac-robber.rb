require 'formula'

class MacRobber < Formula
  homepage 'http://www.sleuthkit.org/mac-robber/'
  url 'http://downloads.sourceforge.net/project/mac-robber/mac-robber/1.02/mac-robber-1.02.tar.gz'
  md5 '6d6d99aa882a46b2bc5231d195fdb595'

  def install
    system "make", "CC=#{ENV.cc}", "GCC_OPT=#{ENV.cflags}"
    bin.install 'mac-robber'
  end
end
