class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "http://jmvdveer.home.xs4all.nl/algol.html"
  url "http://jmvdveer.home.xs4all.nl/algol68g-2.8.2.tar.gz"
  sha256 "bf0416b296e4935908a39b12688822d0b017d3dbb74cb4dc0ab2a15184c9ddb1"

  bottle do
    sha256 "743088c848c897a040700199d9d21ba4e4b418f9f4510b8d29c36bb013732cc6" => :yosemite
    sha256 "6e5187b65256def5155d53c259fd37d950d96ea97d4d9a4db3182c02e9df02c4" => :mavericks
    sha256 "d1467497abb2a0c0bc7c3f78aadaf811052984d79177f977165870064270b0bb" => :mountain_lion
  end

  depends_on "gsl" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<-EOS.undent
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
