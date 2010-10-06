require 'formula'

def build_clang?; ARGV.include? '--with-clang'; end

class Clang <Formula
  url       'http://llvm.org/releases/2.8/clang-2.8.tgz'
  homepage  'http://llvm.org/'
  md5       '10e14c901fc3728eecbd5b829e011b59'
end

class Llvm <Formula
  url       'http://llvm.org/releases/2.8/llvm-2.8.tgz'
  homepage  'http://llvm.org/'
  md5       '6b13c504c718385fa0a4d375275e7a05'

  def options
    [['--with-clang', 'Also build & install clang']]
  end

  def install
    ENV.gcc_4_2 # llvm can't compile itself

    if build_clang?
      clang_dir = Pathname.new(Dir.pwd)+'tools/clang'
      Clang.new.brew { clang_dir.install Dir['*'] }
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-targets=host-only",
                          "--enable-optimized"
    system "make" # seperate steps required, otherwise the build fails
    system "make install"

    if build_clang?
      Dir.chdir clang_dir do
        system "make install"
      end
    end
  end
end
