require "formula"

class GraphTool < Formula
  homepage "http://graph-tool.skewed.de/"
  url "http://downloads.skewed.de/graph-tool/graph-tool-2.2.35.tar.bz2"
  sha1 "f75a31dec45843beff18eb6b5ce8eda5a0645277"

  option "with-graphs", "build the dependencies required for graph drawing"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "gdk-pixbuf"
  depends_on "pygobject"
  depends_on "boost"
  depends_on "boost-python"
  depends_on "expat"
  depends_on "cgal"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "librsvg"
  depends_on "google-sparsehash" => :recommended
  depends_on "graphviz" => :optional
  depends_on "scipy" => :python
  depends_on "numpy" => :python

  if build.with? "graphs"
    depends_on "cairomm" => "without-x11"
    depends_on "py2cairo" => "without-x11"
    # This sucks. This really sucks. Provides a terrible user experience.
    # FIXTHIS: Find a way to serve a working self-contained python-deps installation.
    depends_on "matplotlib" => :python
  end

  def install
    if build.with? "google-sparsehash"
      ENV["SPARSEHASH_CFLAGS"] = "#{Formula["google-sparsehash"].opt_prefix}/include"
      ENV["SPARSEHASH_LIBS"] = "#{Formula["google-sparsehash"].opt_prefix}/lib"
    end

    args = [ "--prefix=#{prefix}",
             "--disable-silent-rules",
             "--disable-dependency-tracking",
             "--with-python-module-path=#{lib}/python2.7/site-packages"
    ]

    args << "--disable-cairo" if build.without? "graphs"
    args << "--disable-sparsehash" if build.without? "google-sparsehash"

    system "./configure", *args
    system "make", "install"
  end
end
