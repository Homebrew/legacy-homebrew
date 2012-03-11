require 'formula'

class Cjdns < Formula
  homepage 'https://github.com/cjdelisle/cjdns'
  head 'https://github.com/cjdelisle/cjdns.git'

  depends_on 'cmake' => :build
  depends_on 'libevent'
  depends_on 'nacl'

  def install
    system "mkdir build"

    cd "build" do
      system "cmake .. #{std_cmake_parameters}"
      system "make"
      system "make test"
      bin.install 'cjdroute'
    end
  end
end