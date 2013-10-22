require 'formula'

class UpnpRouterControl < Formula
  homepage 'https://launchpad.net/upnp-router-control'
  url 'https://launchpad.net/upnp-router-control/trunk/0.2/+download/upnp-router-control-0.2.tar.gz'
  sha1 '4d6b22430f784260fccb2f70c27d0a428b9a753a'

  head do
    url 'bzr://lp:upnp-router-control'

    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'gupnp'
  depends_on 'gssdp'
  depends_on 'curl' => :optional
  depends_on :x11

  def install
    system "./autogen.sh" if build.head?

    # Recent gupnp pc files don't export symbols from gssdp
    # Bug Ref: https://bugs.launchpad.net/upnp-router-control/+bug/1100236
    if not build.head?
      ENV.append_to_cflags %x[pkg-config --cflags gssdp-1.0].chomp
      ENV['LIBS'] = %x[pkg-config --libs gssdp-1.0].chomp
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
