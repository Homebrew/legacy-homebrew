require 'formula'

class DbusGlib < Formula
  homepage 'http://www.freedesktop.org/Software/dbus'
  url 'http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.102.tar.gz'
  sha1 '58a8955972f6c221461a49f9c541c22e838a5776'

  bottle do
    revision 1
    sha1 "51b2423a45fd72b5476a2b3c7f8c7d3716c38976" => :yosemite
    sha1 "a3ed176614007538b3fd7e788e0a72e4710b3762" => :mavericks
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
