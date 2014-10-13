require "formula"

class Kyua < Formula
  homepage "https://github.com/jmmv/kyua"
  url "https://github.com/jmmv/kyua/releases/download/kyua-0.10/kyua-0.10.tar.gz"
  sha1 "cb2c78c6bf2ab4f543eba61dd3ace75db0de27dc"

  bottle do
    sha1 "b01a65c236678fce2a1b6e93f9c8edd1b0cafeb0" => :mavericks
    sha1 "561f9b7a4a88f6187ad9e438225efab55511260e" => :mountain_lion
    sha1 "e29ab8d8fb98c383b0097e2b9e6fc32b8d2e9876" => :lion
  end

  depends_on "atf"
  depends_on "lutok"
  depends_on "pkg-config" => :build
  depends_on "lua"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make", "install"
  end
end
