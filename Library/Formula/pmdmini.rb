class Pmdmini < Formula
  desc "Plays music in PC-88/98 PMD chiptune format"
  homepage "https://github.com/BouKiCHi/mdxplayer"
  url "https://github.com/mistydemeo/pmdmini/archive/v1.0.0.tar.gz"
  sha256 "526cb2be1a7e32be9782908cbaeae89b3aca20cad8e42f238916ce9b6d17679c"

  bottle do
    cellar :any
    sha256 "8ef0ae46fdad41c5b9a5d87bbc790647f08f66dd6eef06a68f8f0fcaa9b17a31" => :el_capitan
    sha256 "9270b4bce1d5cdc0e2b3e482e7ad66419b22758218f4cf1beea5f2fae41f761a" => :yosemite
    sha256 "cbeadbd17026f4f4d1bbf12c5a4f196d6974d07e46fca66c0e79247eb69338ee" => :mavericks
  end

  option "with-lib-only", "Do not build commandline player"
  deprecated_option "lib-only" => "with-lib-only"

  depends_on "sdl" if build.without? "lib-only"

  resource "test_song" do
    url "ftp://ftp.modland.com/pub/modules/PMD/Shiori%20Ueno/His%20Name%20Is%20Diamond/dd06.m"
    sha256 "36be8cfbb1d3556554447c0f77a02a319a88d8c7a47f9b7a3578d4a21ac85510"
  end

  def install
    # Specify Homebrew's cc
    inreplace "mak/general.mak", "gcc", ENV.cc
    if build.with? "lib-only"
      system "make", "-f", "Makefile.lib"
    else
      system "make"
    end

    # Makefile doesn't build a dylib
    system "#{ENV.cc} -dynamiclib -install_name #{lib}/libpmdmini.dylib -o libpmdmini.dylib -undefined dynamic_lookup obj/*.o"

    bin.install "pmdplay" if build.without? "lib-only"
    lib.install "libpmdmini.a", "libpmdmini.dylib"
    (include+"libpmdmini").install Dir["src/*.h"]
    (include+"libpmdmini/pmdwin").install Dir["src/pmdwin/*.h"]
  end

  test do
    resource("test_song").stage testpath
    (testpath/"pmdtest.c").write <<-EOS.undent
    #include <stdio.h>
    #include "libpmdmini/pmdmini.h"

    int main(int argc, char** argv)
    {
        char title[1024];
        pmd_init();
        pmd_play(argv[1], argv[2]);
        pmd_get_title(title);
        printf("%s\\n", title);
    }
    EOS
    system ENV.cc, "pmdtest.c", "-lpmdmini", "-o", "pmdtest"
    result = `#{testpath}/pmdtest #{testpath}/dd06.m #{testpath}`.chomp
    assert_equal "mus #06", result
  end
end
