require "formula"

class Kyua < Formula
  homepage "https://github.com/jmmv/kyua"
  url "https://github.com/jmmv/kyua/releases/download/kyua-0.10/kyua-0.10.tar.gz"
  sha1 "cb2c78c6bf2ab4f543eba61dd3ace75db0de27dc"

  depends_on "lua52"
  depends_on "lutok" => :build
  depends_on "pkg-config" => :build
  depends_on "sqlite"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
