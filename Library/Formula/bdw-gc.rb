require 'formula'

class BdwGc < Formula
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.2c.tar.gz'
  sha1 '18c5b1aa9289a12fead3ceeda8fdc81f4ed08964'

  def fails_with :clang
    build 421
    cause 'Segfault 11 during make check'
  end

  def options
    [['--universal', 'Make a 32/64-bit Intel build.']]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make check"
    system "make install"
  end
end
