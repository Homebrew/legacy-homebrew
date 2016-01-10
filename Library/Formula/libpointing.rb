class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "http://libpointing.org/homebrew/libpointing-0.92.tar.gz"
  sha256 "df7b36d3af35c24fb82564e8109c72c8bda59e9e909bf8372118e28cf0ac5114"

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
