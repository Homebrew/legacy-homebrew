require 'brewkit'

class Wireshark <Formula
  @url='http://media-2.cacetech.com/wireshark/src/wireshark-1.0.8.tar.bz2'
  @md5='09d895f111ee768cc0d7c7e2c427c496'
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
