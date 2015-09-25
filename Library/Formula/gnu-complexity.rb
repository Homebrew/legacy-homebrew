class GnuComplexity < Formula
  desc "Measures complexity of C source"
  homepage "https://www.gnu.org/software/complexity"
  url "http://ftpmirror.gnu.org/complexity/complexity-1.2.tar.xz"
  sha256 "22c275e79078bf438dd51108256bb9b33d111330c3f979d7bf1cb0d4aa055e24"

  depends_on "autogen" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"complexity", "--version"
  end
end
