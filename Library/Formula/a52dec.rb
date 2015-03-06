require 'formula'

class A52dec < Formula
  homepage 'http://liba52.sourceforge.net/'
  url 'http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz'
  sha1 '79b33bd8d89dad7436f85b9154ad35667aa37321'

  def install
    # Fix error ld: imdct.lo: relocation R_X86_64_32 against `.bss' can not be
    # used when making a shared object; recompile with -fPIC
    ENV.append_to_cflags "-fPIC" unless OS.mac?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--mandir=#{man}"
    system "make install"
  end
end
