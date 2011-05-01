require 'formula'

class Gdb < Formula
  url 'http://ftp.gnu.org/gnu/gdb/gdb-7.2.tar.bz2'
  homepage 'http://www.gnu.org/software/gdb/'
  md5 '64260e6c56979ee750a01055f16091a5'

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
    In order to make this build of gdb useful, you may have to code sign
    the binary. In order to do this, you must create a certificate in your
    System keychain. For more information, see:

    http://sourceware.org/gdb/wiki/BuildingOnDarwin
    EOS
  end
end
