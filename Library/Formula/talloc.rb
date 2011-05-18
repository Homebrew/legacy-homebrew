require 'formula'

class Talloc < Formula
  url 'http://samba.org/ftp/talloc/talloc-2.0.1.tar.gz'
  homepage 'http://talloc.samba.org/'
  md5 'c6e736540145ca58cb3dcb42f91cf57b'

  # Don't try to install the swig files to /usr/share
  def patches
    {:p0 => 'https://trac.macports.org/export/78013/trunk/dports/devel/talloc/files/patch-tallocmk.diff'}
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install TALLOC_SOLIB=libtalloc.2.0.1.dylib TALLOC_SONAME=libtalloc.2.dylib SONAMEFLAG='-Wl,-dylib_install_name,' EXTRA_TARGETS="

    ln_s 'libtalloc.2.0.1.dylib', prefix + 'lib/libtalloc.2.dylib'
    ln_s 'libtalloc.2.dylib', prefix + 'lib/libtalloc.dylib'
  end
end
