require 'formula'

class Wireshark <Formula
  url 'http://media-2.cacetech.com/wireshark/src/wireshark-1.4.0.tar.bz2'
  md5 '13b188baea23cdad40b7a55921384a77'
  homepage 'http://www.wireshark.org'

  depends_on 'gnutls' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-wireshark" # actually just disables the GTK GUI
    system "make"
    ENV.j1 # Install failed otherwise.
    system "make install"
  end

  def caveats
    "We don't build the X11-enabled GUI by default"
  end
end
