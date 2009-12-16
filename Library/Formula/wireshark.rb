require 'formula'

class Wireshark <Formula
  @url='http://media-2.cacetech.com/wireshark/src/wireshark-1.0.10.tar.bz2'
  @md5='facf1eef2f126a9d45e5c30702dae12b'
  @homepage='http://www.wireshark.org'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-wireshark" # actually just disables the GTK GUI
    system "make install"
  end
  
  def caveats
    "We don't build the X11 enabled GUI by default"
  end
end
