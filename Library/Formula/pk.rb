require 'formula'

class Pk < Formula
  homepage 'https://github.com/johnmorrow/pk'
  url 'https://github.com/johnmorrow/pk/releases/download/v1.0.2/pk-1.0.2.tar.gz'
  sha1 'cb8e6bb08d1c31d35e6be823d7c082e9fa700edb'

  depends_on 'argp-standalone'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make test"
    system "make install"
  end

  test do
    system "test \"`echo 1 2 | \"#{bin}/pk\" ..`\" = \"1 2\""
  end
end
