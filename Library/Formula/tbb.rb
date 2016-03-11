class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb44_20160128oss_src_0.tgz"
  sha256 "8d256bf13aef1b0726483af9f955918f04e3de4ebbf6908aa1b0c94cbe784ad7"
  version "4.4-20160128"

  bottle do
    cellar :any
    sha256 "0cf0e393e5a6e1a48fae36e5c3f90bfd23030c9ba190280c1f7eb58ee3890199" => :el_capitan
    sha256 "e1c15f6313b69d6b214d4dbe6e8d79b53179f3ec649ac51dcb775a2eabccadfb" => :yosemite
    sha256 "33d6f509064574263767772e3563a1466e4a9c2208b94ae74ef51f1bae694b32" => :mavericks
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
