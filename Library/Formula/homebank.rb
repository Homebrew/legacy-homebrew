require 'formula'

class Homebank < Formula
  homepage 'http://homebank.free.fr'
  url 'http://homebank.free.fr/public/homebank-4.6.2.tar.gz'
  sha1 '7aecd3bd7487b8e563e65ee7ae62f189f9575e99'

  bottle do
    sha1 "059d9c739336c2b049d93052371291bfdc856733" => :mavericks
    sha1 "e249fc319c046a45af46bce1c3e3d27107d883b6" => :mountain_lion
    sha1 "98dcbd9678f945e3d7fd633807d5ad40acdacad3" => :lion
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
