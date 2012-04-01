require 'formula'

class GambitScheme < Formula
  homepage 'http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page'
  url 'http://www.iro.umontreal.ca/~gambit/download/gambit/v4.6/source/gambc-v4_6_4.tgz'
  md5 'f4a65f834b36b7ffbd0292021889a8e3'

  def options
    [
      ['--with-check', 'Execute "make check" before installing. Runs some basic scheme programs to ensure that gsi and gsc are working'],
      ['--enable-shared', 'Build Gambit Scheme runtime as shared library']
    ]
  end

  skip_clean :all

  fails_with_llvm "ld crashes during the build process or segfault at runtime", :build => 2335

  def install
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--infodir=#{info}",
            # Recommended to improve the execution speed and compactness
            # of the generated executables. Increases compilation times.
            "--enable-single-host"]
    args << "--enable-shared" if ARGV.include? '--enable-shared'

    system "./configure", *args
    system "make check" if ARGV.include? '--with-check'

    ENV.j1
    system "make"
    system "make install"
  end
end
