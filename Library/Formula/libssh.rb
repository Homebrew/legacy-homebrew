require "formula"

class Libssh < Formula
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/87/libssh-0.6.3.tar.xz"
  sha1 "8189255e0f684d36b7ca62739fa0cd5f1030a467"
  revision 2

  head "git://git.libssh.org/projects/libssh.git"

  # Build fails on Yosemite. Upstream: https://red.libssh.org/issues/174

  bottle do
    sha1 "84717d23f7d4e59d847bbc2b3b91a2edb9e05709" => :mavericks
    sha1 "92158c3da484ae5073004c9e471bb458c61e08e3" => :mountain_lion
    sha1 "bd75561291499decf22001b0ba09ae41a3089dbb" => :lion
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
