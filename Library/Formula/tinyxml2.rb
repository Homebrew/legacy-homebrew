require "formula"

class Tinyxml2 < Formula
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/2.0.2.tar.gz"
  sha1 "c78a4de58540e2a35f4775fd3e577299ebd15117"
  head "https://github.com/leethomason/tinyxml2.git", :branch => "master"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
