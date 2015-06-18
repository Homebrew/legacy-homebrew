class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.4.0.tar.gz"
  sha256 "5735ccccd638b2e2c275ca254f2f947bdfe34511247a32822985c3c25239e06e"
  head "https://github.com/alanxz/SimpleAmqpClient.git"
  revision 1

  bottle do
    cellar :any
    sha1 "bd274d244f4187fbf464096f09031f273261fbaf" => :yosemite
    sha1 "ba390005dd4fa32f8c886a1d988c985ad8ba11eb" => :mavericks
    sha1 "7f60046c62ba839e2a4df7477d9a5cf23901704d" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "rabbitmq-c"
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <SimpleAmqpClient/SimpleAmqpClient.h>
      #include <string>
      int main() {
        const std::string expected = "test body";
        AmqpClient::BasicMessage::ptr_t msg = AmqpClient::BasicMessage::Create(expected);

        if(msg->Body() != expected) return 1;

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end
