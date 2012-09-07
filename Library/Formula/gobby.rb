require 'formula'

class Gobby < Formula
  homepage 'http://gobby.0x539.de'
  url 'http://releases.0x539.de/gobby/gobby-0.4.94.tar.gz'
  sha1 '921979da611601ee6e220e2396bd2c86f0fb8c66'

  head 'git://git.0x539.de/git/gobby.git'

  depends_on 'pkg-config' => :build
  depends_on 'gtkmm'
  depends_on 'libgsasl'
  depends_on 'libxml++'
  depends_on 'gtksourceview'
  depends_on 'obby'
  depends_on 'gettext'
  depends_on 'hicolor-icon-theme'
  depends_on 'libinfinity'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
