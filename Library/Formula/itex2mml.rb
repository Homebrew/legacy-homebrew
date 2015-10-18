# From: Jacques Distler <distler@golem.ph.utexas.edu>
# You can always find the latest version by checking
#    https://golem.ph.utexas.edu/~distler/code/itexToMML/view/head:/itex-src/itex2MML.h
# The corresponding versioned archive is
#    https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-x.x.x.tar.gz

class Itex2mml < Formula
  desc "Text filter to convert itex equations to MathML"
  homepage "https://golem.ph.utexas.edu/~distler/blog/itex2MML.html"
  url "https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-1.5.1.tar.gz"
  sha256 "09f39f9db83d2693c9c80288644a8121cd268e956e44684722d29cd6343f524c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fac6420289da65bf725409fff047eb99b5aef6e13b495e7ebe5e9e5bc3d2def" => :el_capitan
    sha256 "af798ea3f8d4f0128dbccef9d26857f472caa76bde9f601f5ab9cdcb315ee31f" => :yosemite
    sha256 "f1767334c2aa53a666064e28a298b75e734f671cd6b6ca60ca9b3af91e40cc90" => :mavericks
  end

  def install
    bin.mkpath
    cd "itex-src" do
      system "make"
      system "make", "install", "prefix=#{prefix}", "BINDIR=#{bin}"
    end
  end

  test do
    system "#{bin}/itex2MML", "--version"
  end
end
