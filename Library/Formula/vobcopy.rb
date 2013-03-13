require 'formula'

class Vobcopy < Formula
  homepage 'http://vobcopy.org'
  url 'http://vobcopy.org/download/vobcopy-1.2.0.tar.bz2'
  sha1 'a848a777f0e477d42a20a52718599d5da00c36db'

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
