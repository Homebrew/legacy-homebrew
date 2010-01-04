require 'formula'

class GambitScheme <Formula
  url 'http://www.iro.umontreal.ca/~gambit/download/gambit/v4.5/source/gambc-v4_5_3.tgz'
  homepage 'http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page'
  md5 '716ed47b7a73d90c9426a240e9536f67'

  def options
    [
      ['--with-check', 'Execute "make check" before installing. Runs some basic scheme programs to ensure that gsi and gsc are working'],
      ['--enable-shared', 'Build Gambit Scheme runtime as shared library']
    ]
  end

  def install
    # Gambit Scheme currently fails to build with llvm-gcc
    # (ld crashes during the build process)
    ENV.gcc_4_2
    # Gambit Scheme doesn't like full optimizations
    ENV.O2

    configure_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      # Recommended to improve the execution speed and compactness
      # of the generated executables. Increases compilation times.
      "--enable-single-host"
    ]

    configure_args << "--enable-shared" if ARGV.include? '--enable-shared'

    system "./configure", *configure_args

    system "make check" if ARGV.include? '--with-check'

    ENV.j1
    system "make"
    system "make install"
  end
end
