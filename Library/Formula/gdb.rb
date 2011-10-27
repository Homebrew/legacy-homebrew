require 'formula'

class Gdb < Formula
  url 'http://ftpmirror.gnu.org/gdb/gdb-7.3.1.tar.bz2'
  homepage 'http://www.gnu.org/software/gdb/'
  md5 'b89a5fac359c618dda97b88645ceab47'

  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--with-python=/usr"]

    system "./configure", *args
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
