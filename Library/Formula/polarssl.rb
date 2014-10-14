require "formula"

class Polarssl < Formula
  homepage "https://polarssl.org/"
  url "https://polarssl.org/download/polarssl-1.3.8-gpl.tgz"
  sha1 "82ed8ebcf3dd53621da5395b796fc0917083691d"

  head "https://github.com/polarssl/polarssl.git"

  bottle do
    cellar :any
    sha1 "d4b03d57816b809d3ed454f338f36c4c586a6c8b" => :mavericks
    sha1 "921a0256ff3be3e310a9a9d835341a01f9f5a46e" => :mountain_lion
    sha1 "a2cf94a5c84fade311821c16382777b900c8c272" => :lion
  end

  depends_on "cmake" => :build

  conflicts_with "md5sha1sum", :because => "both install conflicting binaries"

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make", "install"
    # Why does PolarSSL ship with GNU's Hello included? Let's remove that.
    rm "#{bin}/hello"
  end
end
