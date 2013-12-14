require 'formula'

class Iptux < Formula
  homepage 'hicolor-icon-theme'
  url 'https://github.com/iptux-src/iptux/archive/v0.6.1.tar.gz'
  sha1 '634c7e613bb83a18dfaaf6fc965202a390790921'

  depends_on :x11
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'gconf'
  depends_on 'hicolor-icon-theme'
  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
