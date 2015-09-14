class Tbb < Formula
  desc "Rich and complete approach to parallelism in C++"
  homepage "https://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb43_20150611oss_src.tgz"
  sha256 "221f85fe64e11c9638e43b3c57d5750c26683905fc90827c0bcfefdb286e79c9"
  version "4.3-20150611"

  bottle do
    cellar :any
    sha256 "95f3aba5609c56a089346546e807b7c62979f913cb04a2edbc4a155948e471fa" => :el_capitan
    sha256 "b9dc9ced92b25c87cf44fe5e9280364cd715ef48f7ae0f43877bfe51dc84a672" => :yosemite
    sha256 "bb73a51ac2d3438d2138244f6b69298749eb12e2a36895119755d2a1873f6125" => :mavericks
    sha256 "03a178526e7a878080bae4e730e14853afdf8cc6709c0e58d294ac916b6498d1" => :mountain_lion
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
