require 'formula'

class CppNetlib < Formula
  homepage 'http://cpp-netlib.github.com/latest/index.html'
  url 'https://nodeload.github.com/cpp-netlib/cpp-netlib/tar.gz/master'
  sha1 'dac3d9d1efa130edddecdea9a64e1b46e5afe2f8'
  version 'master'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'openssl'

  def install
    ohai "Note: This formula is installing cpp-netlib from master instead of version 0.9.4 due to OSX-related fix in master"

    build_dir = Dir.pwd
    Dir.chdir "#{prefix}" do
      system "cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ #{build_dir}"
      system 'make'
    end
  end

  def test
    Dir.chdir "#{prefix}" do
      system 'make test'
    end
  end
end
