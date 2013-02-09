require 'formula'

class Graphviz < Formula
  homepage 'http://graphviz.org/'
  url 'http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.30.0.tar.gz'
  sha1 '596c1ddf60c5428c5c4700d10f3ea86534195311'

  env :std

  option :universal
  option 'with-bindings', 'Build Perl/Python/Ruby/etc. bindings'
  option 'with-pangocairo', 'Build with Pango/Cairo for alternate PDF output'
  option 'with-freetype', 'Build with FreeType support'
  option 'with-x', 'Build with X11 support'
  option 'with-app', 'Build GraphViz.app (requires full XCode install)'
  option 'with-gts', 'Build with GNU GTS support (required by prism)'

  depends_on :libpng

  depends_on 'pkg-config' => :build
  depends_on 'pango' if build.include? 'with-pangocairo'
  depends_on 'swig' if build.include? 'with-bindings'
  depends_on 'gts' if build.include? 'with-gts'
  depends_on :freetype if build.include? 'with-freetype' or MacOS::X11.installed?
  depends_on :x11 if build.include? 'with-x' or MacOS::X11.installed?
  depends_on :xcode if build.include? 'with-app'

  fails_with :clang do
    build 318
  end

  def patches
    {:p0 =>
      "https://trac.macports.org/export/101998/trunk/dports/graphics/graphviz/files/patch-project.pbxproj.diff",
     :p1 => DATA}
  end

  def install
    ENV.universal_binary if build.universal?
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--without-qt",
            "--with-quartz"]
    args << "--with-gts" if build.include? 'with-gts'
    args << "--disable-swig" unless build.include? 'with-bindings'
    args << "--without-pangocairo" unless build.include? 'with-pangocairo'
    args << "--without-freetype2" unless build.include? 'with-freetype' or MacOS::X11.installed?
    args << "--without-x" unless build.include? 'with-x' or MacOS::X11.installed?

    system "./configure", *args
    system "make install"

    if build.include? 'with-app'
      # build Graphviz.app
      cd "macosx" do
        system "xcodebuild", "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
      end
      prefix.install "macosx/build/Release/Graphviz.app"
    end

    (bin+'gvmap.sh').unlink
  end

  test do
    (testpath/'sample.dot').write <<-EOS.undent
    digraph G {
      a -> b
    }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end

  def caveats
    if build.include? 'with-app'
      <<-EOS
        Graphviz.app was installed in:
          #{prefix}

        To symlink into ~/Applications, you can do:
          brew linkapps
        EOS
    end
  end
end

# fix quartz plugin build, may not be in upstream yet
__END__
diff --git a/plugin/quartz/Makefile.in b/plugin/quartz/Makefile.in
index 20ec9c6..dbeb46b 100644
--- a/plugin/quartz/Makefile.in
+++ b/plugin/quartz/Makefile.in
@@ -89,7 +89,7 @@ libgvplugin_quartz_la_OBJECTS = $(am_libgvplugin_quartz_la_OBJECTS)
 AM_V_lt = $(am__v_lt_$(V))
 am__v_lt_ = $(am__v_lt_$(AM_DEFAULT_VERBOSITY))
 am__v_lt_0 = --silent
-libgvplugin_quartz_la_LINK = $(LIBTOOL) $(AM_V_lt) $(AM_LIBTOOLFLAGS) \
+libgvplugin_quartz_la_LINK = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) \
	$(LIBTOOLFLAGS) --mode=link $(OBJCLD) $(AM_OBJCFLAGS) \
	$(OBJCFLAGS) $(libgvplugin_quartz_la_LDFLAGS) $(LDFLAGS) -o $@
 @WITH_QUARTZ_TRUE@@WITH_WIN32_FALSE@am_libgvplugin_quartz_la_rpath =  \
@@ -128,7 +128,7 @@ am__v_CCLD_ = $(am__v_CCLD_$(AM_DEFAULT_VERBOSITY))
 am__v_CCLD_0 = @echo "  CCLD  " $@;
 OBJCCOMPILE = $(OBJC) $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) \
	$(AM_CPPFLAGS) $(CPPFLAGS) $(AM_OBJCFLAGS) $(OBJCFLAGS)
-LTOBJCCOMPILE = $(LIBTOOL) $(AM_V_lt) $(AM_LIBTOOLFLAGS) \
+LTOBJCCOMPILE = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) \
	$(LIBTOOLFLAGS) --mode=compile $(OBJC) $(DEFS) \
	$(DEFAULT_INCLUDES) $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) \
	$(AM_OBJCFLAGS) $(OBJCFLAGS)
@@ -136,7 +136,7 @@ AM_V_OBJC = $(am__v_OBJC_$(V))
 am__v_OBJC_ = $(am__v_OBJC_$(AM_DEFAULT_VERBOSITY))
 am__v_OBJC_0 = @echo "  OBJC  " $@;
 OBJCLD = $(OBJC)
-OBJCLINK = $(LIBTOOL) $(AM_V_lt) $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) \
+OBJCLINK = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) \
	--mode=link $(OBJCLD) $(AM_OBJCFLAGS) $(OBJCFLAGS) \
	$(AM_LDFLAGS) $(LDFLAGS) -o $@
 AM_V_OBJCLD = $(am__v_OBJCLD_$(V))
