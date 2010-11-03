require 'formula'

class Wireshark <Formula
  url 'http://media-2.cacetech.com/wireshark/src/wireshark-1.4.1.tar.bz2'
  md5 '1719d20a10990e7c2cb261df7021aab6'
  homepage 'http://www.wireshark.org'

  depends_on 'gnutls' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'

  if ARGV.include? "--with-x"
    depends_on 'gtk+'
  end

  def options
    [
      ["--with-x", "Include X11 support"],
    ]
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
    ]

    if not ARGV.include? "--with-x"
      args << "--disable-wireshark" # actually just disables the GTK GUI
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Install failed otherwise.
    system "make install"
  end
end
