class Ejdb < Formula
  homepage "http://ejdb.org"
  url "https://github.com/Softmotions/ejdb/archive/v1.2.5.tar.gz"
  sha256 "31bbfefed5f892be84aa7748e84ffa0f5645654d4919d2be0f0e25f3fe62638b"

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args - %w{-DCMAKE_BUILD_TYPE=None}
    cmake_args << "-DCMAKE_BUILD_TYPE=Release"
    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make install"
    end
  end
end
