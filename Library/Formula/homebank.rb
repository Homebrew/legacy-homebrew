require 'formula'

class Homebank < Formula
  homepage 'http://homebank.free.fr'
  url 'http://homebank.free.fr/public/homebank-4.6.3.tar.gz'
  sha1 '9393f947fca17cbdb31a2bc7fa03f99ced1c6e68'

  bottle do
    sha1 "03314830a1707ca0c6843258c36b68833d3184ae" => :mavericks
    sha1 "9a6cf54761025d1cd9d27b422eb7e7f0b0ccf746" => :mountain_lion
    sha1 "baf50c3378b4b703b53d1d52b92f4f7537994164" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'hicolor-icon-theme'
  depends_on 'freetype'
  depends_on 'fontconfig'
  depends_on 'libofx' => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-ofx" if build.with? 'libofx'

    system "./configure", *args
    system "chmod +x ./install-sh"
    system "make install"
  end
end
