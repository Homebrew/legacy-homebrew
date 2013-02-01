require 'formula'

class GtkMacIntegration < Formula
  homepage 'https://live.gnome.org/GTK+/OSX'
  url 'ftp://ftp.gnome.org/pub/gnome/sources/gtk-mac-integration/2.0/gtk-mac-integration-2.0.1.tar.xz'
  version '2.0.1'
  sha1 '9d939a2e4fb6c0ab4fe3d544ac712a152451249a'
  head 'git://git.gnome.org/gtk-mac-integration'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'

  fails_with :clang

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
    
    prefix.install "src/.libs/test-integration"
    (prefix + "src").install "src/testui.xml"
  end

  def test
    system "cd #{prefix} && ./test-integration"
  end
end
