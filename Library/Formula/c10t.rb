require 'formula'

# Minecraft cartography tool

class C10t < Formula
  url 'https://github.com/udoprog/c10t/tarball/1.7'
  homepage 'https://github.com/udoprog/c10t'
  md5 '8ba305e2c274469eb8e709f5c68e0c56'

  depends_on 'cmake' => :build
  depends_on 'boost'

  # Needed to compile against newer boost
  # Can be removed for next version of c10t after 1.7
  # See: https://github.com/udoprog/c10t/pull/153
  def patches
    "https://github.com/udoprog/c10t/commit/4a392b9f06d08c70290f4c7591e84ecdbc73d902.diff"
  end

  def install
    inreplace 'CMakeLists.txt', 'boost_thread', 'boost_thread-mt'
    inreplace 'test/CMakeLists.txt', 'boost_unit_test_framework', 'boost_unit_test_framework-mt'
    system "cmake . #{std_cmake_parameters}"
    system "make"
    bin.install "c10t"
  end
end
