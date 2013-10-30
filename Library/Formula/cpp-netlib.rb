require 'formula'

class CppNetlib < Formula
  homepage 'http://cpp-netlib.org'
  url 'https://github.com/cpp-netlib/cpp-netlib/archive/cpp-netlib-0.10.1.tar.gz'
  sha1 'aadfb5f039586d47404a2e473548244e9eeaa1f9'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'openssl'

  def install
    # CXXFLAGS
    cxxflags = "-ftemplate-depth=256"

    system "CXXFLAGS=\"" + cxxflags + "\" cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ ."
    system 'make'

    # Install
    lib.install Dir["libs/network/src/libcppnetlib-*.a"]
    include.install "boost"
  end
end
