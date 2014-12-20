require 'formula'

class Gflags < Formula
  homepage 'http://code.google.com/p/google-gflags/'
  url 'https://github.com/schuhschuh/gflags/archive/v2.1.1.tar.gz'
  sha1 '59b37548b10daeaa87a3093a11d13c2442ac6849'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end
end
