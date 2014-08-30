require 'formula'

class Libevent < Formula
  homepage 'http://libevent.org'
  url 'https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz'
  sha1 '3e6674772eb77de24908c6267c698146420ab699'

  bottle do
    cellar :any
    sha1 "b02833c4b3bae479169e98e02640d54f0399c536" => :mavericks
    sha1 "4cb2ac89054de52fa0d4e001d5df5d17f9855a71" => :mountain_lion
    sha1 "eab82e104a488a3367b1cbd9cd01a885c6ed1df6" => :lion
  end

  head do
    url 'https://github.com/libevent/libevent.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => :build if build.include? 'enable-manpages'

  option :universal
  option 'enable-manpages', 'Install the libevent manpages (requires doxygen)'

  fails_with :llvm do
    build 2326
    cause "Undefined symbol '_current_base' reported during linking."
  end

  # Enable manpage generation
  patch :DATA if build.include? 'enable-manpages'

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
