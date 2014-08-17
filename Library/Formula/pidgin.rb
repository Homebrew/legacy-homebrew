require 'formula'

class Pidgin < Formula
  homepage 'http://pidgin.im/'
  url 'https://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.9/pidgin-2.10.9.tar.bz2'
  sha1 'f3de8fd94dba1f4c98d5402a02430f9f323e665a'
  revision 1

  bottle do
    sha1 "e039a6633ee9110630b5b7406fc9c465b10d34e2" => :mavericks
    sha1 "052f83d0798c770489cdee0cc1e4b6da7b858fff" => :mountain_lion
    sha1 "812f2081647fcbeaacd5beb70e1a84850365a283" => :lion
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
    url "http://www.cypherpunks.ca/otr/pidgin-otr-4.0.0.tar.gz"
    sha1 "23c602c4b306ef4eeb3ff5959cd389569f39044d"
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
