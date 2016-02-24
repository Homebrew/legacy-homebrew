class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/jmmv/lutok"
  url "https://github.com/jmmv/lutok/releases/download/lutok-0.4/lutok-0.4.tar.gz"
  sha256 "2cec51efa0c8d65ace8b21eaa08384b77abc5087b46e785f78de1c21fb754cd5"

  bottle do
    cellar :any
    sha256 "13097eaebfc90aa12e0327a6755e0b6a46e2019a3c263b80e2eac8dd70cf67d7" => :el_capitan
    sha256 "77f3b994f16d7db59f2a3b7093d03d8772323f076b0f7b3da8c2223d4eceb573" => :mavericks
    sha256 "cb7bd53bddc35866f72338d2832f5c92784e3bbee5a6ab9ff2b81a694611eb0d" => :mountain_lion
    sha256 "2d7f8b4d667d0e0c00315db6a1251ccd89ebc2127c06f5187e27fc0f92cd0bff" => :lion
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
