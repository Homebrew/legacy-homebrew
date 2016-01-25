class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/tatsuhiro-t/nghttp2/releases/download/v1.7.0/nghttp2-1.7.0.tar.xz"
  sha256 "0de13c21507b01e80531bbe69617ce2b8a33305a74f22ec3b5b0d111a5daeeb5"

  bottle do
    sha256 "d986ca9939b83cb03941d5bb6d74e25a6427f26af25f1db92d2323a3fc556aff" => :el_capitan
    sha256 "74d3cfd9c905a31a48458f8031e76b4982610e40b4544abb21646be4b3e7688f" => :yosemite
    sha256 "6dde03d9b591e262e12a820906c1c7aa2c7b8e01d41a4aed7ff09a9d55dc2f8c" => :mavericks
  end

  head do
    url "https://github.com/tatsuhiro-t/nghttp2.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "libxml2" # Needs xml .m4 available
  end

  option "with-examples", "Compile and install example programs"
  option "without-docs", "Don't build man pages"
  option "with-python3", "Build python3 bindings"

  depends_on :python3 => :optional
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "pkg-config" => :build
  depends_on "cunit" => :build
  depends_on "libev"
  depends_on "openssl"
  depends_on "libevent"
  depends_on "jansson"
  depends_on "boost"
  depends_on "spdylay" => :recommended

  resource "Cython" do
    url "https://pypi.python.org/packages/source/C/Cython/Cython-0.23.1.tar.gz"
    sha256 "bdfd12d6a2a2e34b9a1bbc1af5a772cabdeedc3851703d249a52dcda8378018a"
  end

  # https://github.com/tatsuhiro-t/nghttp2/issues/125
  # Upstream requested the issue closed and for users to use gcc instead.
  # Given this will actually build with Clang with cxx11, just use that.
  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --with-boost=#{Formula["boost"].opt_prefix}
      --enable-asio-lib
    ]

    args << "--enable-examples" if build.with? "examples"
    args << "--with-spdylay" if build.with? "spdylay"
    args << "--disable-python-bindings"

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"

    # Currently this is not installed by the make install stage.
    if build.with? "docs"
      system "make", "html"
      doc.install Dir["doc/manual/html/*"]
    end

    system "make", "install"
    libexec.install "examples" if build.with? "examples"

    if build.with? "python3"
      pyver = Language::Python.major_minor_version "python3"
      ENV["PYTHONPATH"] = cythonpath = buildpath/"cython/lib/python#{pyver}/site-packages"
      cythonpath.mkpath
      ENV.prepend_create_path "PYTHONPATH", lib/"python#{pyver}/site-packages"

      resource("Cython").stage do
        system "python3", *Language::Python.setup_install_args(buildpath/"cython")
      end

      cd "python" do
        system buildpath/"cython/bin/cython", "nghttp2.pyx"
        system "python3", *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
