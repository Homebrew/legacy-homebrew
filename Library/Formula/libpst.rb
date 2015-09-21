class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.65.tar.gz"
  sha256 "89e895f6d70c125dd9953f42069c1aab601ed305879b5170821e33cee3c94e23"

  bottle do
    cellar :any
    sha256 "aa3c7936beb062ce12570429c321a3538add1039f9f5dcf57a105f30a2e27b1a" => :el_capitan
    sha256 "9ee327766259c9fe31b61c42a506d1c6d34463e10695e4426871ec41d7a84433" => :yosemite
    sha256 "d7a025eb8594adefbe85bb80c4604a600a7be9f068f7e9052ae64b40199c0767" => :mavericks
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
