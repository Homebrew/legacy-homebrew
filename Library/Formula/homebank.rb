require 'formula'

class Homebank < Formula
  homepage 'http://homebank.free.fr'
  url 'http://homebank.free.fr/public/homebank-4.6.1.tar.gz'
  sha1 '0e37c8421cbf8a681afc2e155262b28f8acaa5f6'

  bottle do
    sha1 "b6f8da52acbb1332d36edacf64071ab9afff773d" => :mavericks
    sha1 "673f740b3db289f3a9e2d48abf2a8c59270a30a1" => :mountain_lion
    sha1 "315ec100c255836cffaa29bd3b2bbcfc68f6eb64" => :lion
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
