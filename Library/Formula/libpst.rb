class Libpst < Formula
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.63.tar.gz"
  sha256 "5f522606fb7b97d6e31bc2490dcce77b89ec77e12ade4af4551290f953483062"

  bottle do
    cellar :any
    sha1 "b90a60bae5163fa853ea1e1bfe8c4149d0287457" => :yosemite
    sha1 "143ec60a13f3ccfbb46cb9039ac31505f5b904e5" => :mavericks
    sha1 "7d0df0df98649f182c6b493eab1fc6ad77b7b1f7" => :mountain_lion
  end

  option "with-pst2dii", "Build pst2dii using gd"

  deprecated_option "pst2dii" => "with-pst2dii"

  depends_on :python => :optional
  depends_on "pkg-config" => :build
  depends_on "gd" if build.with? "pst2dii"
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"
  depends_on "boost-python" if build.with? "python"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-dii" if build.with? "pst2dii"

    if build.with? "python"
      args << "--enable-python" << "--with-boost-python=mt"
    else
      args << "--disable-python"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
