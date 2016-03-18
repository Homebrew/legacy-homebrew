class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.2.0.tar.gz"
  sha256 "5327e0c0faa37643f59be6f086576ef76a13d36b655d2bf9547f89ffce3b3413"
  head "https://github.com/dvidelabs/flatcc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c3d7e80159dbf1093b063c31f666edde6e7e61e47effff056e195dcc5a4eb80" => :el_capitan
    sha256 "b3262d360e57e751104e7a587c502a2db50485a09bf507650f39cbb4506ae853" => :yosemite
    sha256 "a02998f4da5d62c97c54b75d3d9d014ec3cf7758109687777507c8f832e2f7bb" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", buildpath, *std_cmake_args
    system "make"

    bin.install "bin/flatcc"
    lib.install "lib/libflatcc.a"
    lib.install "lib/libflatccrt.a"
    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.fbs").write <<-EOS.undent
      // example IDL file

      namespace MyGame.Sample;

      enum Color:byte { Red = 0, Green, Blue = 2 }

      union Any { Monster }  // add more elements..

        struct Vec3 {
          x:float;
          y:float;
          z:float;
        }

        table Monster {
          pos:Vec3;
          mana:short = 150;
          hp:short = 100;
          name:string;
          friendly:bool = false (deprecated);
          inventory:[ubyte];
          color:Color = Blue;
        }

      root_type Monster;

      EOS

    system "flatcc", "-av", "--json", "test.fbs"
  end
end
