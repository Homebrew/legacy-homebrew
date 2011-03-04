require 'formula'

class BdwGc <Formula
  url 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.1.tar.gz'
  homepage 'http://www.hpl.hp.com/personal/Hans_Boehm/gc/'
  md5 '2ff9924c7249ef7f736ecfe6f08f3f9b'

  def install
    fails_with_llvm "LLVM gives an unsupported inline asm error"

    if MACOS_VERSION == 10.6
      # ucontext has been deprecated in 10.6
      # use this flag to force the header to compile
      ENV.append 'CPPFLAGS', "-D_XOPEN_SOURCE"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
