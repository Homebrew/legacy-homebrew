require 'formula'

class taskd < Formula
  homepage 'http://taskwarrior.org'
  url 'http://taskwarrior.org/download/taskd-1.0.0.beta2.tar.gz'
  sha1 'e74f4004db571338f48094d28c7f1c39e772745b'
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
