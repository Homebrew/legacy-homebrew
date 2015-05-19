class Tbb < Formula
  desc "A rich and complete approach to parallelism in C++"
  homepage "http://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb43_20150424oss_src.tgz"
  sha1 "21a3176bf09677b795df2c529065c265a2ad72ae"
  version "4.3-20150424"

  bottle do
    cellar :any
    sha256 "078701a392fbfa4ba14dffa613f393513d14310d7be37ad59545bc63f4350140" => :yosemite
    sha256 "72318b626782997469a0cb47c793bd71b6e984d10feefbb829054f3d44dab361" => :mavericks
    sha256 "247d68f89dc94312446d5fbd8aab5f58f46527c4b988959e331a9f32e122ffae" => :mountain_lion
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
