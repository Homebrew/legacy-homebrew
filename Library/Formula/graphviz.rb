class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "http://graphviz.org/"
  url "http://graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.38.0.tar.gz"
  sha256 "81aa238d9d4a010afa73a9d2a704fc3221c731e1e06577c2ab3496bdef67859e"

  head do
    url "https://github.com/ellson/graphviz.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    revision 1
    sha1 "a3461628baba501e16c63ceaa0414027f7e26c7f" => :yosemite
    sha1 "dc7f915d199931a49fb2a8eb623b329fed6c619c" => :mavericks
    sha1 "ec730f7cdd3e9549610960ecab86dac349e2f8ea" => :mountain_lion
  end

  # To find Ruby and Co.
  env :std

  option :universal
  option "with-bindings", "Build Perl/Python/Ruby/etc. bindings"
  option "with-pango", "Build with Pango/Cairo for alternate PDF output"
  option "with-app", "Build GraphViz.app (requires full XCode install)"
  option "with-gts", "Build with GNU GTS support (required by prism)"

  deprecated_option "with-x" => "with-x11"
  deprecated_option "with-pangocairo" => "with-pango"

  depends_on "pkg-config" => :build
  depends_on :xcode => :build if build.with? "app"
  depends_on "pango" => :optional
  depends_on "gts" => :optional
  depends_on "librsvg" => :optional
  depends_on "freetype" => :optional
  depends_on :x11 => :optional
  depends_on "libpng"

  if build.with? "bindings"
    depends_on "swig" => :build
    depends_on :python
    depends_on :java
  end

  fails_with :clang do
    build 318
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/DomT4/scripts/46364470b/Homebrew_Resources/MacPorts_Import/graphviz/r103168/patch-project.pbxproj.diff"
    mirror "https://trac.macports.org/export/103168/trunk/dports/graphics/graphviz/files/patch-project.pbxproj.diff"
    sha256 "7c8d5c2fd475f07de4ca3a4340d722f472362615a369dd3f8524021306605684"
  end

  def install
    ENV.universal_binary if build.universal?
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--without-qt",
            "--with-quartz"]
    args << "--with-gts" if build.with? "gts"
    args << "--disable-swig" if build.without? "bindings"
    args << "--without-pangocairo" if build.without? "pango"
    args << "--without-freetype2" if build.without? "freetype"
    args << "--without-x" if build.without? "x11"
    args << "--without-rsvg" if build.without? "librsvg"

    if build.with? "bindings"
      # http://www.graphviz.org/mantisbt/view.php?id=2486
      inreplace "configure", 'PYTHON_LIBS="-lpython$PYTHON_VERSION_SHORT"',
                             'PYTHON_LIBS="-L$PYTHON_PREFIX/lib -lpython$PYTHON_VERSION_SHORT"'
    end

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"

    if build.with? "app"
      cd "macosx" do
        xcodebuild "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
      end
      prefix.install "macosx/build/Release/Graphviz.app"
    end

    (bin+"gvmap.sh").unlink
  end

  test do
    (testpath/"sample.dot").write <<-EOS.undent
    digraph G {
      a -> b
    }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
