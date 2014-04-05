require "formula"

class Sysdig < Formula
  homepage "http://www.sysdig.org/"
  url 'https://github.com/draios/sysdig/archive/0.1.72.tar.gz'
  sha1 'c735c37da82022d22f77490b94f178ad98a1e6f6'

  head 'https://github.com/draios/sysdig.git', :branch => 'master'

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sysdig", "-h"
  end
end
