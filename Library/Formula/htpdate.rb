require 'formula'

class Htpdate < Formula
  homepage 'http://www.clevervest.com/htp'
  url 'http://www.clevervest.com/htp/archive/c/htpdate-0.9.1.tar.gz'
  md5 '26f9792ded592e2dd79a6c26d436a4ed'

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  def test
    system "#{bin}/htpdate", "-h"
  end
end
