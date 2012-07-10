require 'formula'

class Libevent < Formula
  homepage 'http://www.monkey.org/~provos/libevent/'
  url 'https://github.com/downloads/libevent/libevent/libevent-2.0.19-stable.tar.gz'
  sha1 '28c109190345ce5469add8cf3f45c5dd57fe2a85'

  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  fails_with :llvm do
    build 2326
    cause "Undefined symbol '_current_base' reported during linking."
  end

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on "doxygen" => :build if ARGV.include? '--enable-manpages'

  # Enable manpage generation
  def patches
    DATA if ARGV.include? '--enable-manpages'
  end

  def options
    [["--enable-manpages", "Install the libevent manpages"],
     ["--universal", "Builds a universal binary"]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    ENV.j1
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"

    if ARGV.include? '--enable-manpages'
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
