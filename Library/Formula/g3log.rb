class G3log < Formula
  desc 'asynchronous, "crash safe", logger that is easy to use.'
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/v1.1.tar.gz"
  sha256 "b6374819ec9ba56807eeaa6f11e889f33550b1296524a5e7831ce9adc1218a9c"

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
