require 'formula'

class BdwGc < Formula
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.1.tar.gz'
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'
  md5 '2ff9924c7249ef7f736ecfe6f08f3f9b'

  # MacPorts patch to fix inline asm errors with LLVM
  # this fix is present in upstream development versions
  def patches
    { :p0 => "https://trac.macports.org/export/86621/trunk/dports/devel/boehmgc/files/asm.patch" }
  end

  def install
    # ucontext has been deprecated in 10.6
    # use this flag to force the header to compile
    ENV.append 'CPPFLAGS', "-D_XOPEN_SOURCE" if MacOS.snow_leopard?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
