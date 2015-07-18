class Cereal < Formula
  desc "C++11 library for serialization"
  homepage "https://uscilab.github.io/cereal/"
  url "https://github.com/USCiLab/cereal/archive/v1.1.2.tar.gz"
  sha256 "45607d0de1d29e84d03bf8eecf221eb2912005b63f02314fbade9fbabfd37b8d"

  head "https://github.com/USCiLab/cereal.git", :branch => "develop"

  bottle do
    cellar :any
    sha1 "e7bbce282665e7e1d392840a1a620371de9fb3af" => :yosemite
    sha1 "2d1bc4e43e82c55eb57cf767683fb7223ab05fef" => :mavericks
    sha1 "2b53401c5d32d2d6263678e2166db000df7dc013" => :mountain_lion
  end

  option "with-tests", "Build and run the test suite"

  depends_on "cmake" => :build if build.with? "tests"

  needs :cxx11

  def install
    ENV.cxx11
    if build.with? "tests"
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
