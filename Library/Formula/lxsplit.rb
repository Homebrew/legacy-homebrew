require 'formula'

class Lxsplit < Formula
  homepage 'http://lxsplit.sourceforge.net/'
  url 'http://downloads.sourceforge.net/lxsplit/lxsplit-0.2.4.tar.gz'
  sha1 '4e906cb95fcc756ff8c5d58c103e2659493052e0'

  def install
    bin.mkpath
    inreplace 'Makefile', '/usr/local/bin', bin
    system "make"
    system "make install"
  end
end
