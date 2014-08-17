require 'formula'

class Libssh < Formula
  homepage 'http://www.libssh.org/'
  url 'https://red.libssh.org/attachments/download/87/libssh-0.6.3.tar.xz'
  sha1 '8189255e0f684d36b7ca62739fa0cd5f1030a467'

  bottle do
    sha1 "93da24a19a5f85ea291968e63fee5a138f4cf6c5" => :mavericks
    sha1 "340b484d2f8dd4958155aee6241efd2182776927" => :mountain_lion
    sha1 "8da4783403ab7b48b4c714ade666cd7d3bce0610" => :lion
  end

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
