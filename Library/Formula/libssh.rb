require 'formula'

class Libssh < Formula
  homepage 'http://www.libssh.org/'
  url 'https://red.libssh.org/attachments/download/41/libssh-0.5.4.tar.gz'
  sha1 '4a372378db8fffaf28d5c79d80b2235843aa587c'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
