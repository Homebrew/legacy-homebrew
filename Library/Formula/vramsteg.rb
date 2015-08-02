require 'formula'

class Vramsteg < Formula
  desc "Add progress bars to command-line applications"
  homepage 'http://tasktools.org/projects/vramsteg.html'
  url 'http://taskwarrior.org/download/vramsteg-1.0.1.tar.gz'
  sha1 'bbc9f54e6e10b3e82dbbac6275e2e611d752e85d'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
