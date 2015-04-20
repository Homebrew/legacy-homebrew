require "formula"

class Pure < Formula
  homepage "http://purelang.bitbucket.org/"
  url "https://bitbucket.org/purelang/pure-lang/downloads/pure-0.64.tar.gz"
  sha1 "738d25de30a20bbdd0722aeb923d6be9051b730f"

  bottle do
    sha1 "02217c59ebfa9d993cac8e8ffc17688ea950bc74" => :yosemite
    sha1 "64dfe09713e22b4a97c3c87d297d7a7dc0662479" => :mavericks
    sha1 "4241d39d6802a115dd75ec11817103a0892dc4e8" => :mountain_lion
  end

  needs :cxx11

  depends_on "llvm"
  depends_on "gmp"
  depends_on "readline"
  depends_on "mpfr"

  resource "docs" do
    url "https://bitbucket.org/purelang/pure-lang/downloads/pure-docs-0.64.tar.gz"
    sha1 "a7cea453195046621497be5ea1d33dce3cb677cc"
  end

  def install
    ENV.cxx11

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-release",
                          "--without-elisp"

    system "make"
    system "make", "install"
    resource("docs").stage { system "make", "prefix=#{prefix}", "install" }
  end

  test do
    system "#{bin}/pure", "--version"
  end
end
