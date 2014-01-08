require 'formula'

class Mdxmini < Formula
  homepage 'http://clogging.web.fc2.com/psp/'
  url 'https://github.com/BouKiCHi/mdxplayer/archive/9afbc01f60a12052817cb14a81a8c3c976953506.tar.gz'
  version '20130115'
  sha1 '8ca3b597f009ee7de697329e26b9f3c402dda173'

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
