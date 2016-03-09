class Libwebm < Formula
  desc "WebM container"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libwebm/archive/libwebm-1.0.0.27.tar.gz"
  sha256 "1332f43742aeae215fd8df1be6e363e753b17abb37447190e789299fe3edec77"

  bottle do
    cellar :any
    sha256 "857027173cb56069854f03e25ca0a3c4cce4dc2bed404ab78af3f41344c52a05" => :yosemite
    sha256 "005679e6d2de745d49c4867dcfbc4490be235a3ba25275ff88e0d518b494e4c7" => :mavericks
    sha256 "3e2c2a2fd1854c158c33bd6667a2e0ae17838eb88a0f839ee48316f59d105c7e" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    mkdir "macbuild" do
      system "cmake", "..", *std_cmake_args
      system "make"
      lib.install "libwebm.a"
      bin.install %w[sample sample_muxer vttdemux webm2pes]
    end
    include.install Dir.glob("mkv*.hpp")
    include.install Dir.glob("vtt*.h")
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <mkvwriter.hpp>
      int main()
      {
        mkvmuxer::MkvWriter writer();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lwebm", "-o", "test"
    system "./test"
  end
end
