require "formula"

class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "http://libpointing.org/homebrew/libpointing-0.92.tar.gz"
  sha1 "a7f20c405e87a4b6fae369f977c0615a621ab143"

  bottle do
    cellar :any
    revision 1
    sha1 "02be7b605af13fbc724fd0d7df55577a81441b54" => :yosemite
    sha1 "5b97a2c58b9101aba98f43de0b7e4753dd32b85b" => :mavericks
    sha1 "402cb8cf65ea6712ad9b0dca43361bdf3fabc9a4" => :mountain_lion
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
