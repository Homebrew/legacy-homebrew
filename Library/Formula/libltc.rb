require "formula"

class Libltc < Formula
  homepage "http://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.1.4/libltc-1.1.4.tar.gz"
  sha1 "b8ff317dc15807aaa7142366b4d13c0c9aa26959"

  bottle do
    cellar :any
    sha1 "d0979ebd91c34b428d3b11fc076c42e2082e2149" => :mavericks
    sha1 "f7ca44ef990b7c3e9d3d2bf65875f1c6c6b90b72" => :mountain_lion
    sha1 "2bca5d496106a59b582914f55c3348096f1e5a94" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
