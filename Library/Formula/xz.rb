require 'formula'

class Xz <Formula
  url 'http://tukaani.org/xz/xz-4.999.9beta.tar.bz2'
  homepage 'http://tukaani.org/xz/'
  md5 'cc4044fcc073b8bcf3164d1d0df82161'
  version '4.999.9beta' # *shrug*

  def install
    # Disable the assembly CRC checks they use x86 rather than x86-64 asm and fail to build for x86-64.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-assembler"
    system "make install"
  end
end
