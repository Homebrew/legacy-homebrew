require 'formula'

class GambitScheme <Formula
  url 'http://www.iro.umontreal.ca/~gambit/download/gambit/v4.6/source/gambc-v4_6_0.tgz'
  homepage 'http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page'
  md5 '4f0e8b3e90a96f2203cbaf1e1cc1388a'

  def options
    [
      ['--with-check', 'Execute "make check" before installing. Runs some basic scheme programs to ensure that gsi and gsc are working'],
      ['--enable-shared', 'Build Gambit Scheme runtime as shared library']
    ]
  end

  def install
    fails_with_llvm "ld crashes during the build process"
    # Gambit Scheme doesn't like full optimizations
    ENV.O2

    configure_args = [
      "--prefix=#{prefix}",
      "--infodir=#{info}",
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
