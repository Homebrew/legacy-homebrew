class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb44_20151115oss_src.tgz"
  sha256 "3dd5c4fc85c18f49307d3cde4ce937bda230679f7fe2906112e5c8dee4cc77bb"
  version "4.4-20151115"

  bottle do
    cellar :any
    sha256 "8132496216419b554d78194f825f043070a4531e205daf9ea3680dc33056876a" => :el_capitan
    sha256 "5e801aa2f73674a08b4b79608aebc834382e8688fc1c8e009ad53e9e6ebd6ee5" => :yosemite
    sha256 "6d0bac1c69920ae841e9de18d4123827071f4419043335fbfe246d864c818e22" => :mavericks
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
