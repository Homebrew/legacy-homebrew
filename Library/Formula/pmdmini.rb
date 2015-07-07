require 'formula'

class Pmdmini < Formula
  desc "Plays music in PC-88/98 PMD chiptune format"
  homepage 'https://github.com/BouKiCHi/mdxplayer'
  url 'https://github.com/BouKiCHi/mdxplayer/archive/aa55d9d3128f06aac4a15d5cefc083bd7b66d814.tar.gz'
  version '20120115'
  sha1 'b312f5b11b62a9d2be910252a97bed7decdef13f'

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
