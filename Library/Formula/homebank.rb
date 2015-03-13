require 'formula'

class Homebank < Formula
  homepage 'http://homebank.free.fr'
  url 'http://homebank.free.fr/public/homebank-5.0.0.tar.gz'
  sha1 'b56659fa0b8c44c6f75b77e87ef22c6239b12b28'

  bottle do
    sha256 "a686d413e57162925b9600e03adb8f02f395b177ae84849d18a454a3e3d7ec19" => :yosemite
    sha256 "262149448eb43781445fa392379d5b85ff4451dfe7bccaaba9e1cfafbe86fb63" => :mavericks
    sha256 "898eaa8859226245bc8f3e3712bf4aad7e062fddee1a9548e119f9317f1792b4" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+3'
  depends_on 'gnome-icon-theme'
  depends_on 'freetype'
  depends_on 'fontconfig'
  depends_on 'libofx' => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-ofx" if build.with? 'libofx'

    system "./configure", *args
    chmod 0755, "./install-sh"
    system "make install"
  end
end
