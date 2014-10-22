require 'formula'

class Pidgin < Formula
  homepage 'http://pidgin.im/'
  url 'https://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.9/pidgin-2.10.9.tar.bz2'
  sha1 'f3de8fd94dba1f4c98d5402a02430f9f323e665a'
  revision 1

  bottle do
    revision 1
    sha1 "430aef531d3993806a044c16ce86b55a19cf8d15" => :yosemite
    sha1 "0dc523a911e1a5b08d0103858904ee67e91ac688" => :mavericks
    sha1 "0b158a8e1657695a480df0cc170f83a9558cc9c7" => :mountain_lion
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
