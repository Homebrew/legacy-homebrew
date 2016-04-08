class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "http://www.fltk.org/"

  stable do
    url "https://fossies.org/linux/misc/fltk-1.3.3-source.tar.gz"
    sha256 "f8398d98d7221d40e77bc7b19e761adaf2f1ef8bb0c30eceb7beb4f2273d0d97"

    # Fltk 1.3.4 include support for El Capitan. Remove on update.
    depends_on MaximumMacOSRequirement => :yosemite

    # Fixes issue with -lpng not found.
    # Based on: https://trac.macports.org/browser/trunk/dports/aqua/fltk/files/patch-src-Makefile.diff
    patch :DATA
  end

  bottle do
    revision 1
    sha256 "69949c963a94d37d0bee674b9ae4ac5a5ee830da810c5f55ddfbcf48eba26228" => :yosemite
    sha256 "62854e23f7cd706b433c9a6c383b99bcfb4b7116c1337778aecd1691737f8cb9" => :mavericks
  end

  devel do
    url "http://fltk.org/pub/fltk/snapshots/fltk-1.3.x-r11419.tar.gz"
    sha256 "fd5a445634b799c031d78e7c046cb083779fd2dc79fab072cd512cfb0fc48262"
    version "1.3.3-r11419" # convince brew that this is newer than stable

    depends_on "autoconf" => :build
    depends_on "autogen" => :build
  end

  option :universal

  depends_on "libpng"
  depends_on "jpeg"

  fails_with :clang do
    build 318
    cause "https://llvm.org/bugs/show_bug.cgi?id=10338"
  end

  def install
    ENV.universal_binary if build.universal?

    if build.devel?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
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
