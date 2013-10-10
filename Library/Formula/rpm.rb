require 'formula'

class RpmDownloadStrategy < CurlDownloadStrategy
  def initialize name, resource
    super
    @tarball_name = "#{name}-#{resource.version}.tar.gz"
  end

  def stage
    safe_system "rpm2cpio.pl <#{tarball_path} | cpio -vi #{@tarball_name}"
    safe_system "/usr/bin/tar -xzf #{@tarball_name} && rm #{@tarball_name}"
    chdir
  end

  def ext
    ".src.rpm"
  end
end

class Rpm < Formula
  homepage 'http://www.rpm5.org/'
  url 'http://rpm5.org/files/rpm/rpm-5.4/rpm-5.4.11-0.20130708.src.rpm',
      :using => RpmDownloadStrategy
  version '5.4.11'
  sha1 'a40328cf49f43d33746c503a390e3955f5bd3680'

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

  def patches
    { :p0 => DATA } if MacOS.version >= :mountain_lion
  end

  def install
    args = %W[
        --prefix=#{prefix}
        --localstatedir=#{var}
        --with-path-cfg=#{etc}/rpm
        --with-extra-path-macros=#{lib}/rpm/macros.*
        --disable-openmp
        --disable-nls
        --disable-dependency-tracking
        --with-db=external
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

    system "./configure", *args
    system "make"
    system "make install"
  end
end

__END__
diff -u -rrpm-5_4_11-release -rrpm-5_4
--- system.h	26 Jul 2012 12:56:08 -0000	2.129.2.5
+++ system.h	9 Aug 2013 10:30:22 -0000	2.129.2.8
@@ -323,7 +323,13 @@
 #endif

 #if defined(HAVE_GRP_H)
+#define	uuid_t	unistd_uuid_t	/* XXX Mac OS X dares to be different. */
+#define	uuid_create	unistd_uuid_create
+#define	uuid_compare	unistd_uuid_compare
 #include <grp.h>
+#undef	unistd_uuid_t		/* XXX Mac OS X dares to be different. */
+#undef	unistd_uuid_create
+#undef	unistd_uuid_compare
 #endif

 #if defined(HAVE_LIMITS_H)
