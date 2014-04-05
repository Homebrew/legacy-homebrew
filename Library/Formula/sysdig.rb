require "formula"

class Sysdig < Formula
  homepage "http://www.sysdig.org/"
  url 'https://github.com/draios/sysdig/archive/0.1.73.tar.gz'
  sha1 '2f1133da0256c21c2642dbda57e047a3ae69765f'

  head 'https://github.com/draios/sysdig.git', :branch => 'master'

  depends_on "cmake" => :build

  def install
    ENV.libcxx if MacOS.version < :mavericks

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sysdig", "-h"
  end
end
