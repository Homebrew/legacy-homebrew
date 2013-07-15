require 'formula'

class Autobench < Formula
  homepage 'http://www.xenoclast.org/autobench/'
  url 'http://www.xenoclast.org/autobench/downloads/autobench-2.1.2.tar.gz'
  sha1 '8c342b50ce36c13d46dc995bc5f08acdead21553'

  depends_on 'httperf'

  def install
    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end
end
