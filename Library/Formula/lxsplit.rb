require 'formula'

class Lxsplit < Formula
  url 'http://downloads.sourceforge.net/lxsplit/lxsplit-0.2.4.tar.gz'
  homepage 'http://lxsplit.sourceforge.net/'
  md5 'ed21a08c167c08d4d81c820782947cb1'

  def install
    bin.mkpath
    inreplace 'Makefile', '/usr/local/bin', bin
    system "make"
    system "make install"
  end
end
