class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/jmmv/lutok"
  url "https://github.com/jmmv/lutok/releases/download/lutok-0.4/lutok-0.4.tar.gz"
  sha256 "2cec51efa0c8d65ace8b21eaa08384b77abc5087b46e785f78de1c21fb754cd5"

  bottle do
    cellar :any
    sha256 "13097eaebfc90aa12e0327a6755e0b6a46e2019a3c263b80e2eac8dd70cf67d7" => :el_capitan
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
