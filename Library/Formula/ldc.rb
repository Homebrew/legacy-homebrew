require 'formula'

class Ldc < Formula
  url 'https://github.com/downloads/ldc-developers/ldc/ldc-0.10.0-src.tar.gz'
  sha1 '6cfd64f89d74655dc2896d428ac26331c963f00a'

  head 'https://github.com/ldc-developers/ldc.git'
  homepage 'https://github.com/ldc-developers/ldc/wiki'

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
    system "./test"
  end
end
