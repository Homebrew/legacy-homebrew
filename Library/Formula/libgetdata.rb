require 'formula'

class Libgetdata < Formula
  homepage 'http://getdata.sourceforge.net/'
  url 'http://sourceforge.net/projects/getdata/files/getdata/0.8.3/getdata-0.8.3.tar.bz2'
  sha1 '6db067fd3d1c40cf436cb73c26285c3dfeb902ff'

  option 'lzma',        'Build with LZMA compression support'
  option 'zzip',        'Build with zzip compression support'
  option 'with-fortran','Build Fortran 77 bindings'

  depends_on 'xz'          if build.include? 'lzma'
  depends_on 'libzzip'     if build.include? 'zzip'

  def install

    ENV.fortran if build.with? 'fortran'

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  def patches
    # Fixes include_dirs array breaking strict.  Patch submitted upstream.
    DATA
  end
end

__END__
diff --git a/bindings/perl/Build.PL.in b/bindings/perl/Build.PL.in
index d4e5491..ee20e9c 100644
--- a/bindings/perl/Build.PL.in
+++ b/bindings/perl/Build.PL.in
@@ -42,7 +42,7 @@ my $build = $class->new(
   dist_version_from => "GetData.pm",
   extra_compiler_flags => ['@DEFS@', '-I@top_builddir@/src'],
   extra_linker_flags => ['-L@top_builddir@/src/.libs/', '-lgetdata'],
-  include_dirs => '@top_srcdir@/src',
+  include_dirs => ['@top_srcdir@/src'],
   license => 'lgpl',
   module_name => "GetData",
   pm_files => { 'GetData.pm' => 'lib/GetData.pm' },
