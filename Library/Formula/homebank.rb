require 'formula'

class Homebank < Formula
  homepage 'http://homebank.free.fr'
  url 'http://homebank.free.fr/public/homebank-5.0.1.tar.gz'
  sha1 '225961be412133b5556986c72de9756f30458efe'

  bottle do
    sha256 "e86de98bc6300a17d7ecf7502ca59bcecfdb5f5b67631b886917d27c12c34285" => :yosemite
    sha256 "af4ba7c885c202421c0bdd3571548d89b265fff9bffda2a632e5b08f463d0436" => :mavericks
    sha256 "e489febaee4d5e18440901bb68c05bd90266804ec3e05053eb92a07309eaedd0" => :mountain_lion
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
