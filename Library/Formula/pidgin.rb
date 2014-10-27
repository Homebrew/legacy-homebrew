require 'formula'

class Pidgin < Formula
  homepage 'http://pidgin.im/'
  url 'https://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.10/pidgin-2.10.10.tar.bz2'
  sha1 '81267c35c8d27f2c62320b564fc11af2cc1f3a4a'

  bottle do
    sha1 "8619dec05832868cf29df37382683b2c8d5944e4" => :yosemite
    sha1 "ee004c411e8e8d534eae11a74c8e3bb2fdfb018c" => :mavericks
    sha1 "ecd1805951f73871171f36587323f6ef1aeb82e0" => :mountain_lion
  end

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gnutls'
  depends_on 'gtk+'

  # for pidgin-otr
  depends_on "libotr"

  resource "pidgin-otr" do
    url "https://otr.cypherpunks.ca/pidgin-otr-4.0.1.tar.gz"
    sha1 "e231a2dc72c960f2aa70d8c9d4b05abc6d123085"
  end

  option 'perl', 'Build pidgin with perl support'

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --disable-avahi
      --disable-dbus
      --disable-gevolution
      --disable-gstreamer
      --disable-gstreamer-interfaces
      --disable-gtkspell
      --disable-idn
      --disable-meanwhile
      --disable-vv
      --enable-gnutls=yes
    ]

    args << '--disable-perl' unless build.include? 'perl'

    system "./configure", *args
    system "make install"

    resource("pidgin-otr").stage do
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pidgin --version"
  end
end
