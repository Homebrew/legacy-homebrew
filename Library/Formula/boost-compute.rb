class BoostCompute < Formula
  homepage "https://kylelutz.github.io/compute"
  url "https://github.com/kylelutz/compute/archive/v0.4.tar.gz"
  sha256 "d6986155d01a02b12351d6c9cc6c85498292209c3949b3a4628c0712ec7cf01b"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.cpp").write <<-EOS.undent
      #include <iostream>
      #include <boost/compute/core.hpp>
      int main()
      {
        std::cout << "hello from "
          << boost::compute::system::default_device().name() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "hello", "-I#{include}/compute", "-framework", "OpenCL", testpath/"hello.cpp"
    output = shell_output "./hello"
    assert_match /^hello from /, output
  end
end
