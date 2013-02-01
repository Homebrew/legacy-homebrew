require 'formula'

class Pv < Formula
  homepage 'http://www.ivarch.com/programs/pv.shtml'
  url 'http://www.ivarch.com/programs/sources/pv-1.3.9.tar.bz2'
  sha1 '9ed32eb0c441f9699acd4091e096ca2f4bb6b5ea'

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
