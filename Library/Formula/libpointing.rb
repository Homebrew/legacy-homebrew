class Libpointing < Formula
  desc "Open-source library to get HID events and master transfer functions"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v0.9.3/libpointing-0.9.3.tar.gz"
  sha256 "ddb362e89c39d6fb263e26bfeaf82545858f9ba9f8de510f267fc232cc21e4e6"

  bottle do
    cellar :any
    sha256 "e8825422895ad66442483611a595956629b96c44330c58d0c1258deedd780038" => :el_capitan
    sha256 "1f38e15c67520d25cfd4de393ba0a5d33e5eb1e4ece9c58238fd21599504d826" => :yosemite
    sha256 "c5ab41fb5a72d7d4321b7179c9455ff784e86e1855ff521c0d35d2259fd3bda5" => :mavericks
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
