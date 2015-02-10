class Nghttp2 < Formula
  homepage "https://nghttp2.org"
  url "https://github.com/tatsuhiro-t/nghttp2/releases/download/v0.7.3/nghttp2-0.7.3.tar.xz"
  sha1 "74f6626aa7ebbc13b8f5169d10020da9acb33440"

  bottle do
    cellar :any
    sha1 "819e7bdcf35ddde67da11ee68120f5b45c1fdefd" => :yosemite
    sha1 "c39244f6a7f5480f98399b1dca4626381b8adf1a" => :mavericks
    sha1 "39f6f4ee59f7a79941120ee16f0cab5a4538cf70" => :mountain_lion
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

  depends_on :python => :build if MacOS.version <= :snow_leopard && build.with?("docs")
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "pkg-config" => :build
  depends_on "cunit" => :build
  depends_on "libev"
  depends_on "openssl"
  depends_on "libevent"
  depends_on "jansson"
  depends_on "boost"
  depends_on "spdylay" => :recommended

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz"
    sha1 "3a11f130c63b057532ca37fe49c8967d0cbae1d5"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha1 "002450621b33c5690060345b0aac25bc2426d675"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha1 "fe2c8178a039b6820a7a86b2132a2626df99c7f8"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  # https://github.com/tatsuhiro-t/nghttp2/issues/125
  # Upstream requested the issue closed and for users to use gcc instead.
  # Given this will actually build with Clang with cxx11, just use that.
  needs :cxx11

  def install
    ENV.cxx11

    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath+"sphinx/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(buildpath/"sphinx")
        end
      end
      ENV.prepend_path "PATH", (buildpath/"sphinx/bin")
    end

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-threads
      --enable-app
      --with-boost=#{Formula["boost"].opt_prefix}
      --disable-python-bindings
    ]

    args << "--enable-examples" if build.with? "examples"
    args << "--with-spdylay" if build.with? "spdylay"

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
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
