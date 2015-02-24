require 'formula'

class Points2grid < Formula
  homepage 'https://github.com/CRREL/points2grid'
  url 'https://github.com/CRREL/points2grid/archive/1.3.0.tar.gz'
  sha1 'a12a54a70559d9920753256966bd2ce7eade752c'

  bottle do
    cellar :any
    revision 1
    sha1 "6e0f817d0a1c5fa15d88115df5ab2ffd65f86eb3" => :yosemite
    sha1 "d02a43cb757016963afcca41c7fd610ad420f846" => :mavericks
    sha1 "e89c8c18c41162ce30078bd93cd80509d471047f" => :mountain_lion
  end

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gdal'

  def install
    args = std_cmake_args + ["-DWITH_GDAL=ON"]
    libexec.install "example.las"
    system "cmake", ".", *args
    system "make install"
  end

  test do
    mktemp do
      system bin/"points2grid",
             "-i", libexec/"example.las",
             "-o", "example",
             "--max", "--output_format", "grid"
      assert_equal 5, %x(grep -c '423.820000' < example.max.grid).strip.to_i
    end
  end
end
