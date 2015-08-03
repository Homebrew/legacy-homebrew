class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "http://www.call-cc.org/"
  url "http://code.call-cc.org/releases/4.9.0/chicken-4.9.0.1.tar.gz"
  sha256 "04df7c439c36fc16446bdfa186e7a70258f911d2d826b5216a8e6b1cb2aa2815"

  head "git://code.call-cc.org/chicken-core"

  bottle do
    revision 1
    sha1 "336ed80fce3e2e2d548ad966b4a60d249523592d" => :mavericks
    sha1 "8a8b278480ab05e46452f61e64e4939cb5d12d3d" => :mountain_lion
    sha1 "e2a9863f311099590265704fe410f39de802c600" => :lion
  end

  def install
    ENV.deparallelize

    args = %W[
      PLATFORM=macosx
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      POSTINSTALL_PROGRAM=install_name_tool
    ]

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
  end
end
