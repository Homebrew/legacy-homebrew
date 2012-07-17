require 'formula'

class BdwGc < Formula
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.2.tar.gz'
  md5 'd17aecedef3d73e75387fb63558fa4eb'

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
