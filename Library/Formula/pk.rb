require 'formula'

class Pk < Formula
  homepage 'https://github.com/johnmorrow/pk'
  url 'https://github.com/johnmorrow/pk/releases/download/v1.0.0/pk-1.0.0.tar.gz'
  sha1 '43add5386e49c9e7a22c2a9a26d8630ee3e57d0e'

  depends_on 'argp-standalone'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "echo","A","B","|","pk","2"
  end
end
