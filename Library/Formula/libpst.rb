class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.65.tar.gz"
  sha256 "89e895f6d70c125dd9953f42069c1aab601ed305879b5170821e33cee3c94e23"

  bottle do
    cellar :any
    sha1 "9c4d9e444577b05d8fd6fe9759840f29776639de" => :yosemite
    sha1 "0b7150bc158799b80cdaf6b5cfdfae740214ee96" => :mavericks
    sha1 "f604465213aae3bc5711fa8633cf25e910dd4799" => :mountain_lion
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
