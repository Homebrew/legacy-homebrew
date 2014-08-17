require 'formula'

class Points2grid < Formula
  homepage 'https://github.com/CRREL/points2grid'
  url 'https://github.com/CRREL/points2grid/archive/1.2.1.tar.gz'
  sha1 'afd1b8ac0086b7ac220a3615e0ec1512161a4628'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    libexec.install "example.las"
    system "cmake", ".", *std_cmake_args
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
