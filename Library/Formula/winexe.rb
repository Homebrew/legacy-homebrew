require 'formula'

class Winexe < Formula
  homepage 'http://sourceforge.net/projects/winexe/'
  url 'https://downloads.sourceforge.net/project/winexe/winexe-1.00.tar.gz'
  sha1 'bdb598745953fcad3a9b6bba8f728c2b714a7aeb'

  depends_on 'pkg-config' => :build
  depends_on :autoconf

  # This patch removes second definition of event context, which *should* break the build
  # virtually everywhere, but for some reason it only breaks it on OS X.
  # http://miskstuf.tumblr.com/post/6840077505/winexe-1-00-linux-macos-windows-7-finally-working
  # Added by @vspy
  patch :DATA

  # This Winexe uses "getopts.pl" that is no longer supplied with newer
  # versions of Perl
  resource "Perl4::CoreLibs" do
    url "http://search.cpan.org/CPAN/authors/id/Z/ZE/ZEFRAM/Perl4-CoreLibs-0.003.tar.gz"
    sha1 "ad4c5a9fa8da4f461dc774e5c53136a55413ef2f"
  end

  def install
    if MacOS.version >= :mavericks
      ENV.prepend_create_path 'PERL5LIB', libexec+'lib/perl5'
      resource("Perl4::CoreLibs").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    cd "source4" do
      system "./autogen.sh"
      system "./configure", "--enable-fhs"
      system "make basics idl bin/winexe"
      bin.install "bin/winexe"
    end
  end
end

__END__
diff -Naur winexe-1.00-orig/source4/winexe/winexe.h winexe-1.00/source4/winexe/winexe.h
--- winexe-1.00-orig/source4/winexe/winexe.h    2011-06-18 00:00:00.000000000 +0000
+++ winexe-1.00/source4/winexe/winexe.h 2011-06-18 00:00:00.000000000 +0000
@@ -63,7 +63,7 @@
 int async_write(struct async_context *c, const void *buf, int len);
 int async_close(struct async_context *c);
 
-struct tevent_context *ev_ctx;
+extern struct tevent_context *ev_ctx;
 
 /* winexesvc32_exe.c */
 extern unsigned int winexesvc32_exe_len;
