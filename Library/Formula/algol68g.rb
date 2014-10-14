require 'formula'

class Algol68g < Formula
  homepage 'http://www.xs4all.nl/~jmvdveer/algol.html'
  url 'http://jmvdveer.home.xs4all.nl/algol68g-2.8.tar.gz'
  sha1 '46b43b8db53e2a8c02e218ca9c81cf5e6ce924fd'

  depends_on 'gsl' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<-EOS.undent
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
