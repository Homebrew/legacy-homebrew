class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.66.tar.gz"
  sha256 "92b49939d821091d9d25e27e17c78dbb867f3f9ab5b8f43e2b01ace0677e1f72"

  bottle do
    cellar :any
    sha256 "85e5b6e462c43360ba320bfd0ff8f1df5651071d084204f83c28390a42ee3e8e" => :el_capitan
    sha256 "8c8a952ce7f839a074bd7948ba90b14598d3e3979e821d9122fb612ddd059d04" => :yosemite
    sha256 "2fcd9b451d14f8cec5960acc2ac1fa22f9b6f7ce943ab694ece78f52f5a29161" => :mavericks
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
