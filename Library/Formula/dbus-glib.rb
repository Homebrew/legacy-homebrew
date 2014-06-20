require 'formula'

class DbusGlib < Formula
  homepage 'http://www.freedesktop.org/Software/dbus'
  url 'http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.102.tar.gz'
  sha1 '58a8955972f6c221461a49f9c541c22e838a5776'

  bottle do
    sha1 "6ca096253317cc2add57bd5af718924a391ea8f4" => :mavericks
    sha1 "9fb847d04b08d4f6c17aa8e76e919c899c9c3be1" => :mountain_lion
    sha1 "411565ac6f2a5b74d110c97955ec9d50a25f1996" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'd-bus'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
