require 'formula'

class Libsoup < Formula
  homepage 'http://live.gnome.org/LibSoup'
  url 'http://ftp.acc.umu.se/pub/gnome/sources/libsoup/2.37/libsoup-2.37.2.tar.xz'
  sha256 'df82c51b67f67c3128979d1f3bf20a8ceeea369b6e43aceb16d576d8fc4e8423'

  # NOTE
  # 1) libsoup 2.37.3+ requires glib >= 2.31
  #
  # 2) libsoup 2.37.2 looks for files which were last provided with gnome-keyring
  #    2.28.2 in the source package as:
  #        library/gnome-keyring.h
  #        library/gnome-keyring-1.pc.in
  #
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'd-bus'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-tls-check"
    system "make install"
  end
end
