require 'formula'

class Mdxmini < Formula
  homepage 'http://clogging.web.fc2.com/psp/'
  url 'https://github.com/BouKiCHi/mdxplayer/tarball/3e60c12666cd4fb5fe17bc0651ff883bd54644ad'
  version '20111115'
  sha1 '59e0bf647b0ab563ef030ce67805d7f7c9684bcc'

  option "lib-only", "Do not build commandline player"

  depends_on 'sdl' unless build.include? "lib-only"

  def install
    cd "jni/mdxmini" do
      # Specify Homebrew's cc
      inreplace "mak/general.mak", "gcc", ENV.cc
      if build.include? "lib-only"
        system "make -f Makefile.lib"
      else
        system "make"
      end

      # Makefile doesn't build a dylib
      system "#{ENV.cc} -dynamiclib -install_name #{lib}/libmdxmini.dylib -o libmdxmini.dylib -undefined dynamic_lookup obj/*.o"

      bin.install "mdxplay" unless build.include? "lib-only"
      lib.install "libmdxmini.a", "libmdxmini.dylib"
      (include+'libmdxmini').install Dir['src/*.h']
    end
  end
end
