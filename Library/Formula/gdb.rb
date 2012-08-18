require 'formula'

class Gdb < Formula
  homepage 'http://www.gnu.org/software/gdb/'
  url 'http://ftpmirror.gnu.org/gdb/gdb-7.5.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gdb/gdb-7.5.tar.bz2'
  md5 '24a6779a9fe0260667710de1b082ef61'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-python=/usr",
                          "--with-system-readline"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      http://sourceware.org/gdb/wiki/BuildingOnDarwin
    EOS
  end
end
