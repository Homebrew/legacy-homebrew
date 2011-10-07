require 'formula'

class Vobcopy < Formula
  url 'http://vobcopy.org/download/vobcopy-1.2.0.tar.bz2'
  homepage 'http://vobcopy.org'
  md5 '88f735ccd051093ff40dab4597bc586e'

  depends_on 'libdvdread'
  depends_on 'libdvdcss'

  def install
    system "./configure.sh", "--prefix=#{prefix}",
                             "--mandir=#{man}",
                             "--with-lfs",
                             "--with-dvdread-libs=#{HOMEBREW_PREFIX}"
    system "make"
    system "make install"
  end
end
