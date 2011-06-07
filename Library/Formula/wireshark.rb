require 'formula'

class Wireshark < Formula
  url 'http://wiresharkdownloads.riverbed.com/wireshark/src/wireshark-1.4.7.tar.bz2'
  md5 'b5065426d5524ddc1667314f8256c2b1'
  homepage 'http://www.wireshark.org'

  depends_on 'gnutls' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'
  depends_on 'gtk+' if ARGV.include? "--with-x"

  def options
    [["--with-x", "Include X11 support"]]
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # actually just disables the GTK GUI
    args << "--disable-wireshark" if not ARGV.include? "--with-x"

    system "./configure", *args
    system "make"
    ENV.j1 # Install failed otherwise.
    system "make install"
  end
end

