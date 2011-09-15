require 'formula'

class Gtkx < Formula
  homepage 'http://www.gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.6.tar.bz2'
  sha256 '6f45bdbf9ea27eb3b5f977d7ee2365dede0d0ce454985680c26e5210163bbf37'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  fails_with_llvm "Undefined symbols when linking", :build => "2326" unless MacOS.lion?

  def options
    [
      ["--universal", "Builds a universal binary"],
      ["--quartz", "Builds with Quartz instead of X."]
    ]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    argv = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}", "--disable-glibtest"]

    if ARGV.include? "--quartz"
      ENV.append 'LDFLAGS', "-framework Carbon -framework Cocoa"
      argv << "--with-gdktarget=quartz" << "--disable-introspection"
    end
    system "./configure", *argv
    system "make install"
  end

  def patches
    DATA if MacOS.lion?
  end

  def test
    system "#{bin}/gtk-demo"
  end
  
  def caveats
    "Pango may need to be intalled with --quartz if you want any of its dependencies to have quartz."
  end
end

__END__
--- old/tests/Makefile.in.orig	2011-09-07 16:38:07.000000000 -0500
+++ new/tests/Makefile.in	2011-09-07 16:38:21.000000000 -0500
@@ -89,7 +89,6 @@
 @HAVE_CXX_TRUE@am_autotestkeywords_OBJECTS =  \
 @HAVE_CXX_TRUE@	autotestkeywords-autotestkeywords.$(OBJEXT)
 autotestkeywords_OBJECTS = $(am_autotestkeywords_OBJECTS)
-autotestkeywords_LDADD = $(LDADD)
 AM_V_lt = $(am__v_lt_$(V))
 am__v_lt_ = $(am__v_lt_$(AM_DEFAULT_VERBOSITY))
 am__v_lt_0 = --silent
@@ -687,6 +686,7 @@
 testtooltips_DEPENDENCIES = $(TEST_DEPS)
 testvolumebutton_DEPENDENCIES = $(TEST_DEPS)
 testwindows_DEPENDENCIES = $(TEST_DEPS)
+autotestkeywords_LDADD = $(LDADD)
 flicker_LDADD = $(LDADDS)
 simple_LDADD = $(LDADDS)
 print_editor_LDADD = $(LDADDS)
