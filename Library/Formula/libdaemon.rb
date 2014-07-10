require 'formula'

class Libdaemon < Formula
  homepage 'http://0pointer.de/lennart/projects/libdaemon/'
  url 'http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz'
  sha1 '78a4db58cf3a7a8906c35592434e37680ca83b8f'

  bottle do
    sha1 "dbebbb1e778d4da01b575a823854070a1bd5e24b" => :mavericks
    sha1 "b773a6e8b9d4cf0388235cb676a65a7b4760e37c" => :mountain_lion
    sha1 "8e36faae400922e0f4294b10d916f1c3d03cbeae" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
