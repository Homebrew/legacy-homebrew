require 'formula'

class Librsvg < Formula
  homepage 'https://live.gnome.org/LibRsvg'
  url 'http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.36/librsvg-2.36.3.tar.xz'
  sha256 '3d7d583271030e21acacc60cb6b81ee305713c9da5e98429cbd609312aea3632'

  bottle do
    cellar :any
    sha1 "d01815e453ec00c29de8d5a57652e38df1ae81aa" => :mavericks
    sha1 "5415045a2de814249515a5ec96cb773b6885d939" => :mountain_lion
    sha1 "276af00164ceb754199b2aed99079378b581579e" => :lion
  end

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'libcroco'
  depends_on 'libgsf' => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-Bsymbolic",
            "--enable-tools=yes",
            "--enable-pixbuf-loader=yes",
            "--enable-introspection=no"]

    args << "--enable-svgz" if build.with? 'libgsf'

    system "./configure", *args
    system "make install"
  end
end
