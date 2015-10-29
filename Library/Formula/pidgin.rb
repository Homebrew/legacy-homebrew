class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.10.11/pidgin-2.10.11.tar.bz2"
  sha256 "f2ae211341fc77efb9945d40e9932aa535cdf3a6c8993fe7919fca8cc1c04007"
  revision 1

  bottle do
    revision 5
    sha256 "854c81ff4f98653156fecb49b0d8736def6c3507da9ab47982c540f1913cb418" => :el_capitan
    sha256 "67e7892b128e2b5589cd7649c74bb449aa54adf133789ff1a0a3bd9f3c52ec57" => :yosemite
    sha256 "8d6452281c705226b987d79ae1642a256ec010a47a613d2674c0750215efe528" => :mavericks
    sha256 "b7daac4be432e5420d690750c8403486edbcb3ba173f4165c32f2aa79b85859f" => :mountain_lion
  end

  option "with-perl", "Build Pidgin with Perl support"
  option "without-gui", "Build only Finch, the command-line client"

  deprecated_option "perl" => "with-perl"
  deprecated_option "without-GUI" => "without-gui"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gsasl" => :optional
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn"
  depends_on "glib"

  if build.with? "gui"
    depends_on "gtk+"
    depends_on "cairo"
    depends_on "pango"
    depends_on "libotr"
  end

  # Finch has an equal port called purple-otr but it is a NIGHTMARE to compile
  # If you want to fix this and create a PR on Homebrew please do so.
  resource "pidgin-otr" do
    url "https://otr.cypherpunks.ca/pidgin-otr-4.0.1.tar.gz"
    sha256 "1b781f48c27bcc9de3136c0674810df23f7d6b44c727dbf4dfb24067909bf30a"
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
      --disable-meanwhile
      --disable-vv
      --without-x
    ]

    args << "--disable-perl" if build.without? "perl"
    args << "--enable-cyrus-sasl" if build.with? "gsasl"

    args << "--with-tclconfig=#{MacOS.sdk_path}/usr/lib"
    args << "--with-tkconfig=#{MacOS.sdk_path}/usr/lib"
    if build.without? "gui"
      args << "--disable-gtkui"
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "gui"
      resource("pidgin-otr").stage do
        ENV.prepend "CFLAGS", "-I#{Formula["libotr"].opt_include}"
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
