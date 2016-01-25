class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb44_20151115oss_src.tgz"
  sha256 "3dd5c4fc85c18f49307d3cde4ce937bda230679f7fe2906112e5c8dee4cc77bb"
  version "4.4-20151115"

  bottle do
    cellar :any
    sha256 "b11025b78347ee6fb889742421bb565df55634c29e5c86eda7999587462d7a60" => :el_capitan
    sha256 "926ffaf0439792e21854d37bea69409eeb4cbb071da4e06ae6e0c41e7bc2141a" => :yosemite
    sha256 "f22cef18da392b3b6c61d830e30d9156123b5b8474b51315dc46ff6aafbb002d" => :mavericks
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
