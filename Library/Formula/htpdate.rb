require 'formula'

class Htpdate < Formula
  homepage 'http://www.clevervest.com/htp'
  url 'http://www.clevervest.com/htp/archive/c/htpdate-0.9.1.tar.gz'
  sha1 '0c8ca300491d12d0bbb3950c8b6c41ba5225c3fa'

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
