require 'formula'

class Pmdmini < Formula
  homepage 'https://github.com/BouKiCHi/mdxplayer'
  url 'https://github.com/BouKiCHi/mdxplayer/tarball/aa55d9d3128f06aac4a15d5cefc083bd7b66d814'
  version '20120115'
  md5 '7d8152d5b59bfc2b535972fe6b5096b4'

  option "lib-only", "Do not build commandline player"

  depends_on 'sdl' unless build.include? "lib-only"

  def install
    cd "jni/pmdmini" do
      # Specify Homebrew's cc
      inreplace "mak/general.mak", "gcc", ENV.cc
      if build.include? 'lib-only'
        system "make", "-f", "Makefile.lib"
      else
        system "make"
      end

      # Makefile doesn't build a dylib
      system "#{ENV.cc} -dynamiclib -install_name #{lib}/libpmdmini.dylib -o libpmdmini.dylib -undefined dynamic_lookup obj/*.o"

      bin.install "pmdplay" unless build.include? 'lib-only'
      lib.install "libpmdmini.a", "libpmdmini.dylib"
      (include+'libpmdmini').install Dir['src/*.h']
      (include+'libpmdmini/pmdwin').install Dir['src/pmdwin/*.h']
    end
  end
end
