class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "http://jmvdveer.home.xs4all.nl/algol.html"
  url "http://jmvdveer.home.xs4all.nl/algol68g-2.8.2.tar.gz"
  sha256 "bf0416b296e4935908a39b12688822d0b017d3dbb74cb4dc0ab2a15184c9ddb1"

  bottle do
    sha256 "fdc60030a0c5ca5787a8bc88e9f365f4c9ab9b9a792ab058a9792b3f539674ea" => :el_capitan
    sha256 "14dc332e1aa14ad318b6a5878fca573360f54bc1ef3adef87ac3e739974ac3fc" => :yosemite
    sha256 "7ebe13640eb6cab2163f37aa013ddf3adf94c887160940deacb1b30bc15c1f51" => :mavericks
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
