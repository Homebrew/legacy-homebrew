class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "http://www.partio.us"
  url "https://github.com/wdas/partio/archive/v1.1.0.tar.gz"
  sha256 "133f386f076bd6958292646b6ba0e3db6d1e37bde3b8a6d1bc4b7809d693999d"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "doxygen" => :build

  # These fixes are upstream and can be removed in the next released version.
  patch do
    url "https://github.com/wdas/partio/commit/5b80b00ddedaef9ffed19ea4e6773ed1dc27394e.diff"
    sha256 "f3808c2b8032f35fee84d90ebaaa8f740376129cd5af363a32ea1e0f92d9282a"
  end

  patch do
    url "https://github.com/wdas/partio/commit/bdce60e316b699fb4fd813c6cad9d369205657c8.diff"
    sha256 "144bdd9c8f490a26e1f39cd1f15be06f8fcbe3cdc99d43abf307bfd25dc5402e"
  end

  patch do
    url "https://github.com/wdas/partio/commit/e557c212b0e8e0c4830e7991541686d568853afd.diff"
    sha256 "f73a6db9ab41eb796f929264a47eba7b0c8826e4590f0caa7679c493aa21b382"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
  end
end
