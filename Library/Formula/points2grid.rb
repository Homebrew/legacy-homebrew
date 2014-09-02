require 'formula'

class Points2grid < Formula
  homepage 'https://github.com/CRREL/points2grid'
  url 'https://github.com/CRREL/points2grid/archive/1.3.0.tar.gz'
  sha1 'a12a54a70559d9920753256966bd2ce7eade752c'

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
