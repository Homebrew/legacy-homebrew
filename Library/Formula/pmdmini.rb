class Pmdmini < Formula
  desc "Plays music in PC-88/98 PMD chiptune format"
  homepage "https://github.com/BouKiCHi/mdxplayer"
  url "https://github.com/mistydemeo/pmdmini/archive/v1.0.0.tar.gz"
  sha256 "526cb2be1a7e32be9782908cbaeae89b3aca20cad8e42f238916ce9b6d17679c"

  option "with-lib-only", "Do not build commandline player"
  deprecated_option "lib-only" => "with-lib-only"

  depends_on "sdl" unless build.without? "lib-only"

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

    bin.install "pmdplay" unless build.with? "lib-only"
    lib.install "libpmdmini.a", "libpmdmini.dylib"
    (include+"libpmdmini").install Dir["src/*.h"]
    (include+"libpmdmini/pmdwin").install Dir["src/pmdwin/*.h"]
  end
end
