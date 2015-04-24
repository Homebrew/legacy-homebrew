class Mdxmini < Formula
  homepage "http://clogging.web.fc2.com/psp/"
  url "https://github.com/BouKiCHi/mdxplayer/archive/ae219b67a9d2a82f43ba35323c1d85d33959d319.tar.gz"
  version "20140608"
  sha256 "a3c4f1b60a3771826de9d3615a7485126818811a3b119ee1354e7b1cb84b66b3"

  bottle do
    cellar :any
    sha256 "c40c860c49f6dacda1d7a0e240349fb917555e8b80b75451569a423ac7bec6a3" => :yosemite
    sha256 "e2ccb5b94304f95607769d614ff8ab89f773848adc394ac648ad69bcca0443cb" => :mavericks
    sha256 "d4cddad73364a53e86f102ae3da0b4f9276b4be834dbd7fe87c08bdc8da84284" => :mountain_lion
  end

  option "with-lib-only", "Do not build commandline player"
  deprecated_option "lib-only" => "with-lib-only"

  depends_on "sdl" if build.without? "lib-only"

  def install
    cd "jni/mdxmini" do
      # Specify Homebrew's cc
      inreplace "mak/general.mak", "gcc", ENV.cc
      if build.with? "lib-only"
        system "make", "-f", "Makefile.lib"
      else
        system "make"
      end

      # Makefile doesn't build a dylib
      system ENV.cc, "-dynamiclib", "-install_name", "#{lib}/libmdxmini.dylib",
        "-o", "libmdxmini.dylib", "-undefined", "dynamic_lookup", *Dir["obj/*.o"]

      bin.install "mdxplay" if build.without? "lib-only"
      lib.install "libmdxmini.dylib"
      (include/"libmdxmini").install Dir["src/*.h"]
    end
  end

  test do
    assert (include/"libmdxmini/class.h").exist?
  end
end
