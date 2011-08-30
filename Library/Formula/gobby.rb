require 'formula'

class Gobby < Formula
  url 'http://releases.0x539.de/gobby/gobby-0.4.12.tar.gz'
  head 'git://git.0x539.de/git/gobby.git'
  homepage 'http://gobby.0x539.de'
  md5 '835cc48f5177196e4a18610c2cb013bf'
  
  depends_on 'pkg-config' => :build
  depends_on 'gtkmm'
  depends_on 'libxml++'
  depends_on 'gtksourceview'
  depends_on 'obby'
  depends_on 'gettext'
  depends_on 'hicolor-icon-theme'

  def install
    ENV.x11
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
