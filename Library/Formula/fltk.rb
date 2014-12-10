require "formula"

class Fltk < Formula
  homepage "http://www.fltk.org/"
  url "http://fossies.org/linux/misc/fltk-1.3.3-source.tar.gz"
  sha1 "873aac49b277149e054b9740378e2ca87b0bd435"

  bottle do
    sha1 "33c75cce41deadbfe54bdcc22ae91d17d3ecc782" => :mavericks
    sha1 "3674769086a1a667379c94aa50aa59b5f66f75d3" => :mountain_lion
  end

  option :universal

  depends_on "libpng"
  depends_on "jpeg"

  fails_with :clang do
    build 318
    cause "http://llvm.org/bugs/show_bug.cgi?id=10338"
  end

  # Fixes issue with -lpng not found.
  # Based on: https://trac.macports.org/browser/trunk/dports/aqua/fltk/files/patch-src-Makefile.diff
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make install"
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index fcad5f0..5a5a850 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -360,7 +360,7 @@ libfltk_images.1.3.dylib: $(IMGOBJECTS) libfltk.1.3.dylib
 		-install_name $(libdir)/$@ \
 		-current_version 1.3.1 \
 		-compatibility_version 1.3.0 \
-		$(IMGOBJECTS)  -L. $(LDLIBS) $(IMAGELIBS) -lfltk
+		$(IMGOBJECTS)  -L. $(LDLIBS) $(IMAGELIBS) -lfltk $(LDFLAGS)
 	$(RM) libfltk_images.dylib
 	$(LN) libfltk_images.1.3.dylib libfltk_images.dylib
