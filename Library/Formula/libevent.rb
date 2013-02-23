require 'formula'

class Libevent < Formula
  homepage 'http://www.monkey.org/~provos/libevent/'
  url 'https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz'
  sha1 '3e6674772eb77de24908c6267c698146420ab699'

  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on "doxygen" => :build if build.include? 'enable-manpages'

  option :universal
  option 'enable-manpages', 'Install the libevent manpages (requires doxygen)'

  fails_with :llvm do
    build 2326
    cause "Undefined symbol '_current_base' reported during linking."
  end

  # Enable manpage generation
  def patches
    DATA if build.include? 'enable-manpages'
  end

  def install
    ENV.universal_binary if build.universal?
    ENV.j1
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"

    if build.include? 'enable-manpages'
      system "make doxygen"
      man3.install Dir['doxygen/man/man3/*.3']
    end
  end
end

__END__
diff --git a/Doxyfile b/Doxyfile
index 5d3865e..1442c19 100644
--- a/Doxyfile
+++ b/Doxyfile
@@ -175,7 +175,7 @@ LATEX_HIDE_INDICES     = NO
 # If the GENERATE_MAN tag is set to YES (the default) Doxygen will 
 # generate man pages
 
-GENERATE_MAN           = NO
+GENERATE_MAN           = YES
 
 # The MAN_EXTENSION tag determines the extension that is added to 
 # the generated man pages (default is the subroutine's section .3)
