class Libmatheval < Formula
  desc "Symbolic math parsing and evaluation"
  homepage "https://www.gnu.org/software/libmatheval/"
  url "http://ftpmirror.gnu.org/gnu/libmatheval/libmatheval-1.1.11.tar.gz"
  sha256 "474852d6715ddc3b6969e28de5e1a5fbaff9e8ece6aebb9dc1cc63e9e88e89ab"
  depends_on "homebrew/versions/guile18"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "ls", "#{lib}/libmatheval.a"
    system "ls", "#{lib}/libmatheval.dylib"
  end
end
