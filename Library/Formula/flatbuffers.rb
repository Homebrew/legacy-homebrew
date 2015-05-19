class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.0.3.tar.gz"
  sha1 "8daba5be5436b7cb99f1883e3eb7f1c5da52d6b9"

  bottle do
    cellar :any
    sha1 "2a82aec99c3b5ab9cd643dc7c6d2f88cfe953cce" => :yosemite
    sha1 "a7222fe66033ca2749241e4d253534b3540b1e7c" => :mavericks
    sha1 "d0de7bdea3b5fd43fddcfe20b857e4ec803a73f2" => :mountain_lion
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
