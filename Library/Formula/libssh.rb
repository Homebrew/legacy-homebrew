require 'formula'

class Libssh < Formula
  homepage 'http://www.libssh.org/'
  url 'https://red.libssh.org/attachments/download/87/libssh-0.6.3.tar.xz'
  sha1 '8189255e0f684d36b7ca62739fa0cd5f1030a467'
  revision 1

  bottle do
    sha1 "7e6ebf36a816f47341f189fa4e21f5a6b6e48257" => :mavericks
    sha1 "5eb0c398255a99af84faf339d4041c212f841737" => :mountain_lion
    sha1 "e2be084fd53f2bb2497a85a5c6499217a418a209" => :lion
  end

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
