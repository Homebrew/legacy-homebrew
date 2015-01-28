class Tbb < Formula
  homepage "http://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb43_20141023oss_src.tgz"
  sha1 "aaecdc97049fbe3c623be46c4e1261b74a1a41a3"
  version "4.3-20141023"

  bottle do
    cellar :any
    sha1 "f3111568e5b600345ca518027771a5169fa4f981" => :yosemite
    sha1 "79e0ed2f2f78f7686a22f155df083ed3a678159a" => :mavericks
    sha1 "ef6d80cc918ee3a2305cf470cb81c48b48e73bd2" => :mountain_lion
  end

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion

  option :cxx11

  def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization

    args = %W[tbb_build_prefix=BUILDPREFIX]

    if build.cxx11?
      ENV.cxx11
      args << "cpp0x=1" << "stdlib=libc++"
    end

    system "make", *args
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]
    include.install "include/tbb"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <tbb/task_scheduler_init.h>
      #include <iostream>

      int main()
      {
        std::cout << tbb::task_scheduler_init::default_num_threads();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-ltbb", "-o", "test"
    system "./test"
  end
end
