require 'formula'

class RpmDownloadStrategy < CurlDownloadStrategy
  def stage
    tarball_name = "#{name}-#{version}.tar.gz"
    safe_system "rpm2cpio.pl <#{cached_location} | cpio -vi #{tarball_name}"
    safe_system "/usr/bin/tar -xzf #{tarball_name} && rm #{tarball_name}"
    chdir
  end

  def ext
    ".src.rpm"
  end
end

class Rpm < Formula
  homepage 'http://www.rpm5.org/'
  url 'http://rpm5.org/files/rpm/rpm-5.4/rpm-5.4.14-0.20131024.src.rpm',
      :using => RpmDownloadStrategy
  version '5.4.14'
  sha1 'ea1a5f073ba4923d32f98b4e95a3f2555824f22c'

  depends_on 'berkeley-db'
  depends_on 'libmagic'
  depends_on 'popt'
  depends_on 'beecrypt'
  depends_on 'libtasn1'
  depends_on 'neon'
  depends_on 'gettext'
  depends_on 'xz'
  depends_on 'ossp-uuid'
  depends_on 'pcre'
  depends_on 'rpm2cpio' => :build

  def install
    args = %W[
        --prefix=#{prefix}
        --localstatedir=#{var}
        --with-path-cfg=#{etc}/rpm
        --with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic
        --with-extra-path-macros=#{lib}/rpm/macros.*
        --with-libiconv-prefix=/usr
        --disable-openmp
        --disable-nls
        --disable-dependency-tracking
        --with-db=external
        --with-sqlite=external
        --with-file=external
        --with-popt=external
        --with-beecrypt=external
        --with-libtasn1=external
        --with-neon=external
        --with-uuid=external
        --with-pcre=external
        --with-lua=internal
        --with-syck=internal
        --without-apidocs
        varprefix=#{var}
    ]

    inreplace "configure", "db-6.0", "db-5.3"
    inreplace "configure", "db_sql-6.0", "db_sql-5.3"
    system "./configure", *args
    inreplace "Makefile", "--tag=CC", "--tag=CXX"
    inreplace "Makefile", "--mode=link $(CCLD)", "--mode=link $(CXX)"
    system "make"
    system "make install"
  end
end
