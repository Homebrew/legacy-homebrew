require 'formula'

class Pv < Formula
  url 'http://www.ivarch.com/programs/sources/pv-1.2.0.tar.bz2'
  homepage 'http://www.ivarch.com/programs/pv.shtml'
  md5 '67aedf6dbcd068d5feeaa76156153f4f'

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-nls"
    system "make install"
  end
end
