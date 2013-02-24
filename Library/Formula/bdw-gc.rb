require 'formula'

class BdwGc < Formula
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'
<<<<<<< HEAD
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.2c.tar.gz'
  sha1 '18c5b1aa9289a12fead3ceeda8fdc81f4ed08964'

  def options
    [['--universal', 'Make a 32/64-bit Intel build.']]
  end
=======
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.2d.tar.gz'
  sha1 'b43573800e27361da78f05a2e98394521cfa04fc'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make check"
    system "make install"
  end
end
