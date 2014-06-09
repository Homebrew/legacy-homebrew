require 'formula'

class Homebank < Formula
  homepage 'http://homebank.free.fr'
  url 'http://homebank.free.fr/public/homebank-4.5.6.tar.gz'
  sha1 '2026b5dba47ff60d893057d270b07931e126af78'

  bottle do
    sha1 "284f95d645b270efd60631cddef64cb6fe5e4a50" => :mavericks
    sha1 "11047cc6cebe54c5cf79128272cb505701f41776" => :mountain_lion
    sha1 "f391c15f37190b3c817085eab4ad6a79210da106" => :lion
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
