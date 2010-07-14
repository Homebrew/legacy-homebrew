require 'formula'

def build_clang?; ARGV.include? '--with-clang'; end

class Clang <Formula
  url       'http://llvm.org/releases/2.7/clang-2.7.tgz'
  homepage  'http://llvm.org/'
  md5       'b83260aa8c13494adf8978b5f238bf1b'
end

class Llvm <Formula
  url       'http://llvm.org/releases/2.7/llvm-2.7.tgz'
  homepage  'http://llvm.org/'
  md5       'ac322661f20e7d6c810b1869f886ad9b'

  def options
    [
      ['--with-clang', 'Also build & install clang']
    ]
  end

  def install
    ENV.gcc_4_2 # llvm can't compile itself

    if build_clang?
      clang_dir = Pathname.new(Dir.pwd)+'tools/clang'
      Clang.new.brew do
        clang_dir.install Dir['*']
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-targets=host-only",
                          "--enable-optimized"
    system "make"
    system "make install" # seperate steps required, otherwise the build fails

    if build_clang?
      Dir.chdir clang_dir do
        system "make install"
      end
    end
  end
end
