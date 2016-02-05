class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.4.0.tar.gz"
  sha256 "5735ccccd638b2e2c275ca254f2f947bdfe34511247a32822985c3c25239e06e"
  head "https://github.com/alanxz/SimpleAmqpClient.git"
  revision 1

  bottle do
    cellar :any
    sha256 "4ce0051362b24556e552aadf852dc98910414ff9ed81d9c9efbbeafb863c8cb6" => :yosemite
    sha256 "37b12090418d4423810cff30c484d0a11736bf856119e9757d9923a381db61bc" => :mavericks
    sha256 "92986f1969aa18e48035b57dedcaec0bf5c098f597b8fa6d573112e4d266958a" => :mountain_lion
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
