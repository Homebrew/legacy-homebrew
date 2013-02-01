#
# Ports File:
# https://trac.macports.org/browser/trunk/dports/sysutils/rpm54/Portfile
#
require 'formula'

class RpmDownloadStrategy < CurlDownloadStrategy
  def stage
    safe_system "rpm2cpio <#{@tarball_path} | cpio -dvim"
    safe_system "tar -xzf #{@unique_token}*gz"
    chdir
  end

  def ext
    ".src.rpm"
  end
end

class Rpm < Formula
  #url 'http://rpm5.org/files/rpm/rpm-5.4/rpm-5.4.9-0.20120508.src.rpm',
  #  :using => RpmDownloadStrategy
  url 'http://rpm5.org/files/rpm/rpm-5.4/rpm-5.4.10-0.20120706.src.rpm',
    :using => RpmDownloadStrategy

  homepage 'http://www.rpm5.org/'
  sha1 '20e5cc7e29ff45b6c5378dbe8ae4af4d1b217971'
  version '5.4.9'

  depends_on 'db'
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
    args = %W[
        --prefix=#{prefix}
        --with-path-cfg=#{etc}/rpm
        --disable-openmp
        --disable-nls
        --disable-dependency-tracking
        --without-apidocs
    ]

    system 'glibtoolize -if' # needs updated ltmain.sh
    system "CC=gcc ./configure", *args
    system "make"
    system "make install"

    # conflicts with rpm2cpio package - which is required for downloading
    system "/bin/rm", "-f", "#{bin}/rpm2cpio"
  end
end
