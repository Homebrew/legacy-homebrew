require 'formula'

class GambitScheme < Formula
  homepage 'http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page'
  url 'http://www.iro.umontreal.ca/~gambit/download/gambit/v4.6/source/gambc-v4_6_6.tgz'
  sha256 '4e8b18bb350124138d1f9bf143dda0ab5e55f3c3d489a6dc233a15a003f161d2'

  option 'with-check', 'Execute "make check" before installing'
  option 'enable-shared', 'Build Gambit Scheme runtime as shared library'

  fails_with :llvm

  def install
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--infodir=#{info}",
            # Recommended to improve the execution speed and compactness
            # of the generated executables. Increases compilation times.
            "--enable-single-host"]
    args << "--enable-shared" if build.include? 'enable-shared'

    unless ENV.compiler == :gcc
      opoo <<-EOS.undent
        Gambit will build with GCC if an acceptable version is found on your
        system, or Clang otherwise.  If it finds only Clang, the build will
        take a very, very long time.  Programs built with Gambit after the
        install may also tke a long time to compile.

        You can remedy this by installing an apple-gcc* or gcc* package.
      EOS
    end

    system "./configure", *args
    system "make check" if build.include? 'with-check'

    ENV.j1
    system "make"
    system "make install"
  end
end
