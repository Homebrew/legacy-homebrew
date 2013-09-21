require 'stringio'

require 'formula'

class Spim < Formula
  homepage 'http://spimsimulator.sourceforge.net/'
  # No source code tarball exists
  url 'http://svn.code.sf.net/p/spimsimulator/code', :revision => 606
  version '9.1.9'

  def install
    bin.mkpath
    system 'cd spim && make'
    system 'cd spim && make install'
  end

  def patches
    # modify Makefile so files install to proper HomeBrew directories
    data = DATA.read
    data.gsub!('$(bin)', bin)
    data.gsub!('$(share)', share)
    data.gsub!('$(man1)', man1)

    StringIO.new(data)
  end

end
__END__
diff --git a/spim/Makefile b/spim/Makefile
index be676a0..a8eded2 100755
--- a/spim/Makefile
+++ b/spim/Makefile
@@ -66,13 +66,13 @@ DOC_DIR = ../Documentation


 # Full path for the directory that will hold the executable files:
-BIN_DIR = $(DESTDIR)/usr/bin
+BIN_DIR = $(bin)

 # Full path for the directory that will hold the exception handler:
-EXCEPTION_DIR = $(DESTDIR)/usr/share/spim
+EXCEPTION_DIR = $(share)

 # Full path for the directory that will hold the man files:
-MAN_DIR = $(DESTDIR)/usr/share/man/man1
+MAN_DIR = $(man1)


 # If you have flex, use it instead of lex.  If you use flex, define this

