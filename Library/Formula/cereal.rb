class Cereal < Formula
  desc "C++11 library for serialization"
  homepage "https://uscilab.github.io/cereal/"
  url "https://github.com/USCiLab/cereal/archive/v1.1.2.tar.gz"
  sha256 "45607d0de1d29e84d03bf8eecf221eb2912005b63f02314fbade9fbabfd37b8d"

  head "https://github.com/USCiLab/cereal.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "08c130ea94d5b20e3314f93deda318f1b2d6177d2be9a490167adb2b021dec81" => :yosemite
    sha256 "f0504c9cc90d6358fdc10d1f075463905d7e581d80e5a45e374976e7bc797b63" => :mavericks
    sha256 "00ef7732975fb675326d0dc1f1a8732b995626075cb5f0a3f2740f28c3fcdda6" => :mountain_lion
  end

  option "with-test", "Build and run the test suite"

  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build if build.with? "tests"

  needs :cxx11

  def install
    ENV.cxx11
    if build.with? "test"
      system "cmake", ".", *std_cmake_args
      system "make"
      system "make", "test"
    end
    include.install "include/cereal"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cereal/types/unordered_map.hpp>
      #include <cereal/types/memory.hpp>
      #include <cereal/archives/binary.hpp>
      #include <fstream>

      struct MyRecord
      {
        uint8_t x, y;
        float z;

        template <class Archive>
        void serialize( Archive & ar )
        {
          ar( x, y, z );
        }
      };

      struct SomeData
      {
        int32_t id;
        std::shared_ptr<std::unordered_map<uint32_t, MyRecord>> data;

        template <class Archive>
        void save( Archive & ar ) const
        {
          ar( data );
        }

        template <class Archive>
        void load( Archive & ar )
        {
          static int32_t idGen = 0;
          id = idGen++;
          ar( data );
        }
      };

      int main()
      {
        std::ofstream os("out.cereal", std::ios::binary);
        cereal::BinaryOutputArchive archive( os );

        SomeData myData;
        archive( myData );

        return 0;
      }
    EOS
    system ENV.cc, "-std=c++11", "-stdlib=libc++", "-lc++", "-o", "test", "test.cpp"
    system "./test"
  end
end
