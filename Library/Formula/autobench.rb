require 'formula'

class Autobench < Formula
  homepage 'http://www.xenoclast.org/autobench/'
  url 'http://www.xenoclast.org/autobench/downloads/autobench-2.1.2.tar.gz'
  md5 'dbd00818840ed8d3c3d35734f0353cff'

  depends_on 'httperf'

  def install
    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end
end
