require 'formula'

class Taskd < Formula
  homepage 'http://taskwarrior.org'
  url 'http://taskwarrior.org/download/taskd-1.0.0.tar.gz'
  sha1 '5a89406a21be1f95ece03674315b35814fe4f037'
  head 'http://tasktools.org/taskd.git'

  depends_on 'cmake' => :build
  depends_on 'gnutls' => :build
  depends_on 'ossp-uuid' => :build
  depends_on 'readline' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
