class Cppcms < Formula
  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://downloads.sourceforge.net/project/cppcms/cppcms/1.0.5/cppcms-1.0.5.tar.bz2"
  sha256 "84b685977bca97c3e997497f227bd5906adb80555066d811a7046b01c2f51865"

  bottle do
    cellar :any
    sha256 "6fec4bca41a688f32b5a8b7cef4de2585b14d59ddedc5967a967917e8727dea0" => :yosemite
    sha256 "fe7c1581986e533596f9d12e4f199ecb1af9a15438d80911829af6365f4d3d05" => :mavericks
    sha256 "b129b55fa688f760864a0cfecbf67c112411518e70c77b6b2c88af0ea2035205" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "pcre"
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.cpp").write <<-EOS.undent
      #include <cppcms/application.h>
      #include <cppcms/applications_pool.h>
      #include <cppcms/service.h>
      #include <cppcms/http_response.h>
      #include <iostream>
      #include <string>

      class hello : public cppcms::application {
          public:
              hello(cppcms::service& srv): cppcms::application(srv) {}
              virtual void main(std::string url);
      };

      void hello::main(std::string /*url*/)
      {
          response().out() <<
              "<html>\\n"
              "<body>\\n"
              "  <h1>Hello World</h1>\\n"
              "</body>\\n"
              "</html>\\n";
      }

      int main(int argc,char ** argv)
      {
          try {
              cppcms::service srv(argc,argv);
              srv.applications_pool().mount(
                cppcms::applications_factory<hello>()
              );
              srv.run();
              return 0;
          }
          catch(std::exception const &e) {
              std::cerr << e.what() << std::endl;
              return -1;
          }
      }
    EOS

    (testpath/"config.json").write <<-EOS.undent
      {
          "service" : {
              "api" : "http",
              "port" : 8080,
              "worker_threads": 1
          },
          "daemon" : {
              "enable" : false
          },
          "http" : {
              "script_names" : [ "/hello" ]
          }
      }
    EOS
    system ENV.cxx, "-o", "hello", "-std=c++11", "-stdlib=libc++", "-lc++", "-lcppcms", "hello.cpp"
    pid = fork { exec "./hello", "-c", "config.json" }

    sleep 1 # grace time for server start
    begin
      assert_match(/Hello World/, shell_output("curl http://127.0.0.1:8080/hello"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
