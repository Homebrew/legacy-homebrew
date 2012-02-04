require 'formula'

class Pmdmini < Formula
  url 'https://github.com/BouKiCHi/mdxplayer/tarball/aa55d9d3128f06aac4a15d5cefc083bd7b66d814'
  md5 '7d8152d5b59bfc2b535972fe6b5096b4'
  homepage 'https://github.com/BouKiCHi/mdxplayer'
  version '20120115'

  depends_on 'sdl' unless ARGV.include? "--lib-only"

  def options
    [
      ["--lib-only", "Do not build commandline player"]
    ]
  end

  def install
    Dir.chdir "jni/pmdmini"
    # Specify Homebrew's cc
    inreplace "mak/general.mak", "gcc", ENV.cc
    if ARGV.include? '--lib-only'
      system "make", "-f", "Makefile.lib"
    else
      system "make"
    end

    # Makefile doesn't build a dylib
    system "#{ENV.cc} -dynamiclib -install_name #{lib}/libpmdmini.dylib -o libpmdmini.dylib -undefined dynamic_lookup obj/*.o"

    bin.install "pmdplay" unless ARGV.include? '--lib-only'
    lib.install "libpmdmini.a"
    lib.install "libpmdmini.dylib"
    (include+'libpmdmini').install Dir['src/*.h']
    (include+'libpmdmini/pmdwin').install Dir['src/pmdwin/*.h']
  end
end
