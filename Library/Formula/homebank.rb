require 'formula'

class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage 'http://homebank.free.fr'
  url 'http://homebank.free.fr/public/homebank-5.0.2.tar.gz'
  sha1 '73517bf16f889ea6dd25120575d1d80c0367f54b'

  bottle do
    sha256 "addd119c70a99456bf8216415a092a8824dbd428ade7349fa8929a1eb9d304da" => :yosemite
    sha256 "9b3a74d65aa3061f6a570f9850c6eaa9947aa6f9f536f7cc5c74df8f3d183803" => :mavericks
    sha256 "2e98d5a10c895c3854824c3249d1c6777b0516123d7b18dc7697c907f01eec47" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+3'
  depends_on 'gnome-icon-theme'
  depends_on 'hicolor-icon-theme'
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
