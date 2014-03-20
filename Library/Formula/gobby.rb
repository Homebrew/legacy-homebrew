require 'formula'

class Gobby < Formula
  homepage 'http://gobby.0x539.de'
  url 'http://releases.0x539.de/gobby/gobby-0.4.94.tar.gz'
  sha1 '921979da611601ee6e220e2396bd2c86f0fb8c66'

  head 'git://git.0x539.de/git/gobby.git'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gtkmm'
  depends_on 'gsasl'
  depends_on 'libxml++'
  depends_on 'gtksourceview'
  depends_on 'gettext'
  depends_on 'hicolor-icon-theme'
  depends_on 'libinfinity'
  depends_on :x11

  # Fix compilation on clang per MacPorts
  patch :p0 do
    url "https://trac.macports.org/export/101720/trunk/dports/x11/gobby/files/patch-code-util-config.hpp.diff"
    sha1 "af0b07d22aa5f442b06cb94ee3e86bf7c05a356a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
