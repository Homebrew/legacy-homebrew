require 'formula'

class Llvm <Formula
  @url='http://llvm.org/releases/2.6/llvm-2.6.tar.gz'
  @homepage='http://llvm.org/'
  @md5='34a11e807add0f4555f691944e1a404a'

  def install
    ENV.gcc_4_2 # llvm can't compile itself

    system "./configure", "--prefix=#{prefix}",
                          "--enable-targets=host-only",
                          "--enable-optimized"
    system "make"
    system "make install" # seperate steps required, otherwise the build fails
  end
end
