require 'formula'

class GambitScheme < Formula
  homepage 'http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page'
  url 'http://www.iro.umontreal.ca/~gambit/download/gambit/v4.6/source/gambc-v4_6_6.tgz'
  sha256 '4e8b18bb350124138d1f9bf143dda0ab5e55f3c3d489a6dc233a15a003f161d2'

  def options
    [
      ['--with-check', 'Execute "make check" before installing. Runs some basic scheme programs to ensure that gsi and gsc are working'],
      ['--enable-shared', 'Build Gambit Scheme runtime as shared library']
    ]
  end

  skip_clean :all

  fails_with :llvm do
    build 2335
    cause "ld crashes during the build process or segfault at runtime"
  end

  def install
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--infodir=#{info}",
            # Recommended to improve the execution speed and compactness
            # of the generated executables. Increases compilation times.
            "--enable-single-host"]
    args << "--enable-shared" if ARGV.include? '--enable-shared'

    unless ENV.compiler == :gcc
      opoo <<-EOS.undent
        Compiling Gambit Scheme with Clang or LLVM-GCC takes a very long time.
        If you have GCC, you can compile it much faster with:
          brew install gambit-scheme --use-gcc
        EOS
    end

    system "./configure", *args
    system "make check" if ARGV.include? '--with-check'

    ENV.j1
    system "make"
    system "make install"
  end
end
