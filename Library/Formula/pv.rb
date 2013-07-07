require 'formula'

class Pv < Formula
  homepage 'http://www.ivarch.com/programs/pv.shtml'
  url 'http://www.ivarch.com/programs/sources/pv-1.4.6.tar.bz2'
  sha1 'c8f66859a7e1d314f1160e3b8fc0e26cf5cdea11'

  depends_on 'gettext'

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
