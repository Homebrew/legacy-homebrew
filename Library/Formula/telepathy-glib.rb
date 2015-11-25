class TelepathyGlib < Formula
  desc "Telepathy GLib library for clients and connection managers"
  homepage "http://telepathy.freedesktop.org/wiki/"
  url "http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.0.tar.gz"
  sha256 "ae0002134991217f42e503c43dea7817853afc18863b913744d51ffa029818cf"

  bottle do
    revision 1
    sha256 "12ad2cfa997e030a3f4e3e49f8cbbb50b026a4fa477c620ed219cef4e075e314" => :el_capitan
    sha256 "3b93cb32a181fa7df3793233c1768b570123db84110104a0262f398e3e828b39" => :yosemite
    sha256 "2a9cd15f3b16ab5d8e2117ae8b4f103395cf9fb5389097281698b36c3b1b923e" => :mavericks
    sha256 "b800179fb44ce04b72e37533543025d64e3661f31192216710c4fc67ec1277fa" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gobject-introspection"
  depends_on "dbus-glib"

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-installed-tests
      --disable-installed-examples
      --disable-gtk-doc-html
    ]

    system "./configure", *args
    system "make", "install"
  end
end
