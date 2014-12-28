require "formula"

class Pidgin < Formula
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.10/pidgin-2.10.10.tar.bz2"
  sha1 "81267c35c8d27f2c62320b564fc11af2cc1f3a4a"

  bottle do
    revision 2
    sha1 "62b0b06637fabb960543e61e4652ee09dfbc1d8f" => :yosemite
    sha1 "7e20e7691b7ebd105e512c4bfb251a9f71c0d21b" => :mavericks
    sha1 "8c03819ed1317164cc29b5de882604a7a017a89f" => :mountain_lion
  end

  deprecated_option "perl" => "with-perl"

  option "with-perl", "Build Pidgin with Perl support"
  option "without-GUI", "Build Finch instead of Pidgin"

  depends_on :x11 => :optional
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "gsasl" => :optional
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libotr"

  if build.without? "GUI"
    depends_on "glib"
    depends_on "libidn"
  end

  # Finch has an equal port called purple-otr but it is a NIGHTMARE to compile
  # If you want to fix this and create a PR on Homebrew please do so.
  resource "pidgin-otr" do
    url "https://otr.cypherpunks.ca/pidgin-otr-4.0.1.tar.gz"
    sha1 "e231a2dc72c960f2aa70d8c9d4b05abc6d123085"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-avahi
      --disable-doxygen
      --enable-gnutls=yes
      --disable-dbus
      --disable-gevolution
      --disable-gstreamer
      --disable-gstreamer-interfaces
      --disable-gtkspell
      --disable-idn
      --disable-meanwhile
      --disable-vv
    ]

    args << "--with-x" if build.with? "GUI"
    args << "--disable-perl" if build.without? "perl"
    args << "--enable-cyrus-sasl" if build.with? "gsasl"

    if build.without? "GUI"
      args << "--with-tclconfig=#{MacOS.sdk_path}/usr/lib"
      args << "--with-tkconfig=#{MacOS.sdk_path}/usr/lib"
      args << "--without-x"
      args << "--disable-gtkui"
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "GUI"
      resource("pidgin-otr").stage do
        ENV.prepend "CFLAGS", "-I#{HOMEBREW_PREFIX}/opt/libotr/include/libotr"
        ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
        system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
        system "make", "install"
      end
    end
  end

  test do
    system "#{bin}/finch", "--version"
  end
end
