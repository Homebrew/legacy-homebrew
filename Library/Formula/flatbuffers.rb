class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.3.0.tar.gz"
  sha256 "b81e11aa101927d464a231d6d3b18ab0e8ea4e959b72f415bb385bae0d74df53"
  head "https://github.com/google/flatbuffers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f481604a3ce126a4b59cb4961d6b6174d734440256c38ccfd2fa8777fdbdd93" => :el_capitan
    sha256 "97abe13a2bbcf541bbf425e59af53c87ddbf38e13b377fbed51ada82fe8d694d" => :yosemite
    sha256 "efa9eb25cc97208767a814ef3b4ec0fc5f118791c43844a69af3e8562e3b624e" => :mavericks
  end

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
