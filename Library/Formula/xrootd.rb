require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.org'
  url 'http://xrootd.org/download/v3.3.6/xrootd-3.3.6.tar.gz'
  sha1 'be1fca000a517933c73c68e40cee6203fd2b6ad6'

  depends_on 'cmake' => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
    share.install prefix/'man'
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
