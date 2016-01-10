class Marst < Formula
  desc "Algol-to-C translator"
  homepage "https://www.gnu.org/software/marst"
  url "http://ftpmirror.gnu.org/marst/marst-2.7.tar.gz"
  sha256 "3ee7b9d1cbe3cd9fb5f622717da7bb5506f1a6da3b30f812e2384b87bce4da50"

  bottle do
    cellar :any
    sha256 "21de984044f371e807240e74c60cf86e591e4fb2ef408cfa917a46ff2645dfd6" => :mavericks
    sha256 "dcf72c779700c73f0628a5b6b8f44abaeaa87f8e9d8cd99b78e22c55d34fdd42" => :mountain_lion
    sha256 "da26535819ad4d3dc429bd2053312727ada90a56d2d48dd8def3810ee1d35d0c" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.alg").write('begin outstring(1, "Hello, world!\n") end')
    system "#{bin}/marst -o hello.c hello.alg"
    system "#{ENV.cc} hello.c -lalgol -lm -o hello"
    system "./hello"
  end
end
