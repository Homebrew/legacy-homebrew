require 'formula'

class Talloc <Formula
  url 'http://samba.org/ftp/talloc/talloc-2.0.1.tar.gz'
  homepage 'http://talloc.samba.org/'
  md5 'c6e736540145ca58cb3dcb42f91cf57b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install TALLOC_SOLIB=libtalloc.2.0.1.dylib TALLOC_SONAME=libtalloc.2.dylib SONAMEFLAG='-Wl,-dylib_install_name,' EXTRA_TARGETS="

    ln_s 'libtalloc.2.0.1.dylib', prefix + 'lib/libtalloc.2.dylib'
    ln_s 'libtalloc.2.dylib', prefix + 'lib/libtalloc.dylib'
  end
end
