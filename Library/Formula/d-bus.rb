require 'formula'

class DBus <Formula
  url 'http://dbus.freedesktop.org/releases/dbus/dbus-1.4.0.tar.gz'
  homepage 'http://www.freedesktop.org/wiki/Software/dbus'
  md5 'f59618b18d2fb2bd1fce9e1c5a2a3282'

  # Don't clean the empty directories that D-Bus needs
  skip_clean "etc/dbus-1/session.d"
  skip_clean "etc/dbus-1/system.d"
  skip_clean "var/run/dbus"

  def install
    # Fix the TMPDIR to one D-Bus doesn't reject due to odd symbols
    ENV["TMPDIR"] = "/tmp"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-xml-docs",
                          "--disable-doxygen-docs",
	                        "--without-x"
    system "make install"

    # Generate D-Bus's UUID for this machine
    system "#{bin}/dbus-uuidgen", "--ensure=#{prefix}/var/lib/dbus/machine-id"
  end
end
