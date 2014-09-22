require "formula"

class Lutok < Formula
  homepage "https://github.com/jmmv/lutok"
  url "https://github.com/jmmv/lutok/releases/download/lutok-0.4/lutok-0.4.tar.gz"
  sha1 "f13ea7cd8344e43c71c41f87c9fdbc2b9047a504"

  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make", "check"
    system "make", "install"
    system "make", "installcheck"
  end
end
