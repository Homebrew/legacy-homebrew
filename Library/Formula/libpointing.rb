class Libpointing < Formula
  desc "Open-source library to get HID events and master transfer functions"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v0.9.3/libpointing-0.9.3.tar.gz"
  sha256 "ddb362e89c39d6fb263e26bfeaf82545858f9ba9f8de510f267fc232cc21e4e6"

  bottle do
    cellar :any
    revision 1
    sha256 "fb544294bb9d75208743783863c2bd0966f8b158a6a914411e52eb6ad3a19614" => :yosemite
    sha256 "620493ef9861892aa784b1f616bc41ca937a6f3aba8577f06acd63fb36d06425" => :mavericks
    sha256 "e59dfc519f194617aed36efa182f77583efa545d05f3b7d2756ade851400a90a" => :mountain_lion
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <pointing/pointing.h>
      #include <iostream>
      int main() {
        std::cout << LIBPOINTING_VER_STRING << " |" ;
        std::list<std::string> schemes = pointing::TransferFunction::schemes() ;
        for (std::list<std::string>::iterator i=schemes.begin(); i!=schemes.end(); ++i) {
          std::cout << " " << (*i) ;
        }
        std::cout << std::endl ;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lpointing", "-o", "test"
    system "./test"
  end
end
