class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.1.0.tar.gz"
  sha256 "6ac776d86e1c9ac84497c51aeac5ddc79c9596166abd937dea073e1cc574a673"

  bottle do
    cellar :any
    sha256 "b5722008fa44851f7a4005d757b40bf2583e8eb8b1861e4bf7f6f21497e66b57" => :yosemite
    sha256 "6f31e9e4cb05aa895ed19562b959c7f736c4688277debb6e5cf8f3f29670a5fd" => :mavericks
    sha256 "ddbf240d9fe9307f82812ac6872899c89d741bb27a2aed54efa3826aea95973f" => :mountain_lion
  end

  head "https://github.com/google/flatbuffers.git"

  depends_on "cmake" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make", "install"
  end

  test do
    def testfbs; <<-EOS.undent
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
    end
    (testpath/"test.fbs").write(testfbs)

    def testjson; <<-EOS.undent
      {
        pos: {
          x: 1,
          y: 2,
          z: 3
        },
        hp: 80,
        name: "MyMonster"
      }
      EOS
    end
    (testpath/"test.json").write(testjson)

    system "flatc", "-c", "-b", "test.fbs", "test.json"
  end
end
