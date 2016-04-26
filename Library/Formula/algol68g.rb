class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-2.8.2.tar.gz"
  sha256 "bf0416b296e4935908a39b12688822d0b017d3dbb74cb4dc0ab2a15184c9ddb1"

  bottle do
    revision 1
    sha256 "bc5f3a74664dd5c74948c0c351108817a053dc13be030e51e00a339b9405132e" => :el_capitan
    sha256 "44ca43b333c52205a6e5e5981f80b4edbe0533a377907ffcef4322037d49c830" => :yosemite
    sha256 "e0e8b42526096a6e40498c159f8b490dd0bb2b5c4d284a17f19a742af4c3d3c2" => :mavericks
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
