class G3log < Formula
  desc 'asynchronous, "crash safe", logger that is easy to use.'
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/1.2.tar.gz"
  sha256 "6fd73ac5d07356b3acdde73ad06f2f40cfc1de11b1864a17375c1177b557c1be"

  bottle do
    cellar :any
    sha256 "6b805ad262286f904a399909d9bcd679a3f7ffb149ce3e54b3ff58569f874236" => :el_capitan
    sha256 "e10a687eeae95b3c6b9ad2d0b1bfbfc7f9c25432e09be7cca2440a31deef34e5" => :yosemite
    sha256 "d23c1c572f56876de3d2b3fa1af8db3820c3eb958b3f9cf5f7386e530af91fe7" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"

    # No install target yet: https://github.com/KjellKod/g3log/issues/49
    include.install "src/g3log"
    lib.install "libg3logger.a", "libg3logger.dylib"
    system "install_name_tool", "-id", "#{lib}/libg3logger.dylib", "#{lib}/libg3logger.dylib"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent.gsub(/TESTDIR/, testpath)
      #include <g3log/g3log.hpp>
      #include <g3log/logworker.hpp>
      int main()
      {
        using namespace g3;
        auto worker = LogWorker::createLogWorker();
        worker->addDefaultLogger("test", "TESTDIR");
        g3::initializeLogging(worker.get());
        LOG(DEBUG) << "Hello World";
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lg3logger", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
