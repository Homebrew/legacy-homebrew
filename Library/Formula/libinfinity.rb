require 'formula'

class Libinfinity < Formula
  homepage 'http://gobby.0x539.de/trac/wiki/Infinote/Libinfinity'
  url 'http://releases.0x539.de/libinfinity/libinfinity-0.5.2.tar.gz'
  md5 '1b2eee8150654baa7bba5900b96ffdc3'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'gnutls'
  depends_on 'libgsasl'

  # MacPorts patch to fix pam include
  def patches
    { :p0 => [
      "https://trac.macports.org/export/92297/trunk/dports/comms/libinfinity/files/patch-infinoted-infinoted-pam.c.diff"
    ]}
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
