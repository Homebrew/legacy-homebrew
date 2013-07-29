require 'formula'

class Pk < Formula
  homepage 'https://github.com/johnmorrow/pk'
  url 'https://github.com/johnmorrow/pk/releases/download/v1.0.1/pk-1.0.1.tar.gz'
  sha1 '8213fc0f80da79783baf0968cb7c7237ee901f4e'

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
