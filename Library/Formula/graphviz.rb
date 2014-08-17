require 'formula'

class Graphviz < Formula
  homepage 'http://graphviz.org/'
  url 'http://graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.38.0.tar.gz'
  sha1 '053c771278909160916ca5464a0a98ebf034c6ef'

  bottle do
    sha1 "112471c5d0e25a953ae64c09db48f434e744f558" => :mavericks
    sha1 "7dcc9f76ce2b8978a77d114354471c7c931a4b54" => :mountain_lion
    sha1 "9effcb470b301098a54566f6d335f2eee6491d71" => :lion
  end

  # To find Ruby and Co.
  env :std

  option :universal
  option 'with-bindings', 'Build Perl/Python/Ruby/etc. bindings'
  option 'with-pangocairo', 'Build with Pango/Cairo for alternate PDF output'
  option 'with-x', 'Build with X11 support'
  option 'with-app', 'Build GraphViz.app (requires full XCode install)'
  option 'with-gts', 'Build with GNU GTS support (required by prism)'

  depends_on "libpng"

  depends_on 'pkg-config' => :build
  depends_on 'pango' if build.with? "pangocairo"
  depends_on 'swig' if build.with? "bindings"
  depends_on 'gts' => :optional
  depends_on "librsvg" => :optional
  depends_on "freetype" => :optional
  depends_on :x11 if build.with? "x"
  depends_on :xcode => :build if build.with? "app"

  fails_with :clang do
    build 318
  end

  patch :p0 do
    url "https://trac.macports.org/export/103168/trunk/dports/graphics/graphviz/files/patch-project.pbxproj.diff"
    sha1 "b242fb8fa81489dd16830e5df6bbf5448a3874d5"
  end

  def install
    ENV.universal_binary if build.universal?
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--without-qt",
            "--with-quartz"]
    args << "--with-gts" if build.with? 'gts'
    args << "--disable-swig" if build.without? "bindings"
    args << "--without-pangocairo" if build.without? "pangocairo"
    args << "--without-freetype2" if build.without? "freetype"
    args << "--without-x" if build.without? "x"
    args << "--without-rsvg" if build.without? "librsvg"

    system "./configure", *args
    system "make install"

    if build.with? "app"
      cd "macosx" do
        xcodebuild "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
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
end
