require 'formula'

class Taskd < Formula
  homepage 'http://taskwarrior.org'
  url 'http://taskwarrior.org/download/taskd-1.0.0.tar.gz'
  sha1 '5a89406a21be1f95ece03674315b35814fe4f037'
  head 'http://tasktools.org/taskd.git'

  depends_on 'cmake' => :build
  depends_on 'gnutls'
  depends_on 'ossp-uuid'
  depends_on 'readline'

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/taskd", 'diagnostics'
  end
end

