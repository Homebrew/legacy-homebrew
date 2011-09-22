require 'formula'

class Mozldap < Formula
  url 'http://ftp.mozilla.org/pub/mozilla.org/directory/c-sdk/releases/v6.0.7/src/mozldap-6.0.7.tar.gz'
  homepage 'https://wiki.mozilla.org/LDAP_C_SDK'
  md5 '6e1b8ace4931a6839fe4cb027d23b5ac'

  depends_on 'svrcore'

  def install
    ENV.deparallelize

    args = ['BUILD_OPT=1']
    args << 'USE_64=1' if MacOS.prefer_64_bit?

    Dir.chdir 'c-sdk' do
      system './configure', '--disable-debug', '--disable-dependency-tracking',
                            "--prefix=#{prefix}",
                            '--enable-clu', '--with-sasl', '--enable-optimize',
                            "#{MacOS.prefer_64_bit? ? '--enable-64bit' : nil}",
                            "--with-nspr-inc=#{HOMEBREW_PREFIX}/include/nspr",
                            "--with-nss-inc=#{HOMEBREW_PREFIX}/include/nss",
                            "--with-ldapsdk-inc=#{HOMEBREW_PREFIX}/include"
      system "make #{args.join(' ')} install"
    end

    # We need to use cp here because all files get cross-linked into the dist
    # hierarchy, and Homebrew's Pathname.install moves the symlink into the keg
    # rather than copying the referenced file.

    Dir.chdir '../dist' do
      bin.mkdir
      Dir["bin/*"].reject { |file| file =~ /\.dylib$/ }.each { |file| cp file, bin }

      etc.mkdir unless File.directory?(etc)
      Dir["etc/*"].each { |file| cp file, etc }

      include.mkdir
      include_target = include + 'mozldap'
      include_target.mkdir
      ['ldap', 'ldap-private'].each do |subdir|
        Dir["public/#{subdir}/*"].each { |file| cp file, include_target }
      end

      lib.mkdir
      Dir["lib/*"].each { |file| cp file, lib }
    end
  end

  def patches
    DATA
  end
end

__END__
# Rationale: http://groups.google.com/group/mozilla.dev.tech.ldap/browse_thread/thread/af564b9426958589
--- a/c-sdk/ldap/clients/tools/convutf8.cpp 2011-01-06 05:05:39.000000000 -0700
+++ b/c-sdk/ldap/clients/tools/convutf8.cpp 2011-09-16 18:20:01.000000000 -0600
@@ -83,13 +83,15 @@
 #elif defined(_WIN32)
 #define LDAPTOOL_CHARSET_DEFAULT	"windows-1252"	/* Windows */
 #define LDAPTOOL_CHARSET_WINANSI	"ANSI"		/* synonym */
+#elif defined(DARWIN)
+#define LDAPTOOL_CHARSET_DEFAULT	"UTF-8"		/* Mac OS X */
 #else
 #define LDAPTOOL_CHARSET_DEFAULT	"646"		/* all others */
 #endif

 /* Type used for the src parameter to iconv() (the 2nd parameter) */
-#if defined(_HPUX_SOURCE) || defined(__GLIBC__)
-#define LDAPTOOL_ICONV_SRC_TYPE	char **		/* HP/UX and glibc (Linux) */
+#if defined(_HPUX_SOURCE) || defined(__GLIBC__) || defined(DARWIN)
+#define LDAPTOOL_ICONV_SRC_TYPE	char **		/* HP/UX, glibc (Linux), and Mac OS X */
 #else
 #define LDAPTOOL_ICONV_SRC_TYPE const char **	/* all others */
 #endif
