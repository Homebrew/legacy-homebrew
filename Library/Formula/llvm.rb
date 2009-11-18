require 'formula'

class Clang <Formula
  url       'http://llvm.org/releases/2.6/clang-2.6.tar.gz'
  homepage  'http://llvm.org/'
  md5       '09d696bf23bb4a3cf6af3c7341cdd946'
end

class Llvm <Formula
  url       'http://llvm.org/releases/2.6/llvm-2.6.tar.gz'
  homepage  'http://llvm.org/'
  md5       '34a11e807add0f4555f691944e1a404a'

  def options
    [
      ['--with-clang', 'Also build & install clang']
    ]
  end

  def clang?
    ARGV.include? '--with-clang'
  end

  def install
    ENV.gcc_4_2 # llvm can't compile itself

    if clang?
      clang_dir = File.join(Dir.pwd, 'tools', 'clang')

      Clang.new.brew {
        FileUtils.mkdir_p clang_dir
        FileUtils.mv Dir['*'], clang_dir
      }
    end

    system "./configure", "--prefix=#{prefix}",
                          "--enable-targets=host-only",
                          "--enable-optimized"
    system "make"
    system "make install" # seperate steps required, otherwise the build fails

    if clang?
      Dir.chdir clang_dir do
        system "make install"
      end
    end
  end
end
