require 'formula'

class Libinfinity < Formula
  homepage 'http://gobby.0x539.de/trac/wiki/Infinote/Libinfinity'
  url 'http://releases.0x539.de/libinfinity/libinfinity-0.5.2.tar.gz'
  sha1 '0864b7f00c44b7bed9f6b69e0e322e0359883358'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'gnutls'
  depends_on 'libgsasl'
  depends_on :x11

  # Reported upstream here: http://gobby.0x539.de/trac/ticket/595
  # Supposedly fixed in HEAD.  Test and remove at libinfinity-0.5.3.
  fails_with :clang do
    build 318
    cause 'Non-void function should return a value'
  end

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
