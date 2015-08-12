class G3log < Formula
  desc 'asynchronous, "crash safe", logger that is easy to use.'
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/v1.1.tar.gz"
  sha256 "b6374819ec9ba56807eeaa6f11e889f33550b1296524a5e7831ce9adc1218a9c"

  bottle do
    cellar :any
    sha256 "bf7272abe06968088c686a82b8eb3e39655adda4d8f6d148b73b34cbf5fd35a0" => :el_capitan
    sha256 "7476145ed1b74e5b1d1f848392368101eaf0b746e6d2f0d498f6e1d2a1052605" => :yosemite
    sha256 "12b9bffc6cbd76355294c3bbd127ea9c44f3d694b15e65f9e9fd9c613a2eacff" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"

    # No install target yet: https://github.com/KjellKod/g3log/issues/49
    include.install "src/g3log"
    lib.install "libg3logger.a"
    lib.install "libg3logger_shared.dylib" => "libg3logger.dylib"
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
