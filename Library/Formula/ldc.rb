require 'formula'

class Ldc < Formula
  url 'http://d32gngvpvl2pi1.cloudfront.net/ldc-0.11.0-src.tar.gz'
  sha1 '2c43e359d4e432611ff46b7bd6703f712f32d5cc'

  head 'https://github.com/ldc-developers/ldc.git'
  homepage 'http://wiki.dlang.org/LDC'

  depends_on 'cmake' => :build
  depends_on 'llvm'
  depends_on 'libconfig'

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    File.open('test.d', 'w') { |f|
      f.write <<-EOF.undent
        import std.stdio;
        int main(string[] args)
        {
          writeln("Test passed.");
          return 0;
        }
      EOF
    }
    system "ldc2", "test.d"
    `"./test"`.strip == "Test passed."
  end
end
