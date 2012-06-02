#
# Ports File:
# https://trac.macports.org/browser/trunk/dports/sysutils/rpm54/Portfile
#
require 'formula'

class Rpm < Formula
  url 'http://rpm5.org/files/rpm/rpm-5.4/rpm-5.4.9-0.20120508.src.rpm'
  homepage 'http://www.rpm5.org/'
  md5 '60d56ace884340c1b3fcac6a1d58e768'
  version '5.4.9'

  depends_on 'db'
  depends_on 'nss'
  depends_on 'nspr'
  depends_on 'libmagic'
  depends_on 'popt'
  depends_on 'beecrypt'
  depends_on 'neon'
  depends_on 'gettext'
  depends_on 'xz'
  depends_on 'ossp-uuid'
  depends_on 'pcre'
  depends_on 'rpm2cpio'
  depends_on 'libtool'

  fails_with :clang do
    build 318
  end

  def install
    ENV.append 'CFLAGS', "-O0 -g"
    args = %W[
        --prefix=#{prefix}
        --disable-openmp
        --disable-nls
        --disable-dependency-tracking
        --without-apidocs 
    ]
    
    system 'glibtoolize -f' # needs updated ltmain.sh
    system "./configure", *args
    system "make"
    system "make install"

    # conflicts with rpm2cpio package - which is required for downloading
    system "/bin/rm", "-f", "#{bin}/rpm2cpio"
  end
end
