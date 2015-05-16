require 'formula'

class Htpdate < Formula
  homepage 'http://www.vervest.org/fiki/bin/view/HTP'
  url 'http://www.vervest.org/htp/archive/c/htpdate-0.9.1.tar.bz2'
  sha1 'e0b1a3ae9ba755471102f28a2b8a7e2dc77addc7'

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-h"
  end
end
