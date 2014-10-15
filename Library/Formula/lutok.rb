require "formula"

class Lutok < Formula
  homepage "https://github.com/jmmv/lutok"
  url "https://github.com/jmmv/lutok/releases/download/lutok-0.4/lutok-0.4.tar.gz"
  sha1 "f13ea7cd8344e43c71c41f87c9fdbc2b9047a504"

  bottle do
    cellar :any
    sha1 "c7f6f6bff0bb2da04a7c736a2f26fa9fefd20e96" => :mavericks
    sha1 "c4a775e93f328abfe36778aefdddea65176d6848" => :mountain_lion
    sha1 "2b408bab3440c0060810599e41a19cede6ce78f4" => :lion
  end

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
