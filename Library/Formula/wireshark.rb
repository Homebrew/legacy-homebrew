require 'formula'

class Wireshark <Formula
  url 'http://media-2.cacetech.com/wireshark/src/wireshark-1.2.9.tar.bz2'
  md5 'a4240c36f1e668d85b703eacb7c0a95e'
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
