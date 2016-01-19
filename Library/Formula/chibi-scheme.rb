class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "http://synthcode.com/wiki/chibi-scheme"
  head "https://github.com/ashinn/chibi-scheme.git"

  stable do
    url "http://synthcode.com/scheme/chibi/chibi-scheme-0.7.3.tgz"
    sha256 "21a0cf669d42a670a11c08f50dc5aedb7b438fae892260900da58f0ed545fc7d"
  end

  bottle do
    revision 2
    sha256 "6427ba91b6fd3e63591d9b1f9c4cd173a53dfbef21acfdf1e41612c07ad4a18f" => :el_capitan
    sha256 "a999ce57390290ecc5452be6bda5f6fb415e565b46eb6806650649a85edce99d" => :yosemite
    sha256 "f29383f76167d2998917a0cfe97e362a7780a1e0288fa17d7132099a41291102" => :mavericks
  end

  def install
    ENV.deparallelize

    # "make" and "make install" must be done separately
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = `#{bin}/chibi-scheme -mchibi -e "(for-each write '(0 1 2 3 4 5 6 7 8 9))"`
    assert_equal "0123456789", output
    assert_equal 0, $?.exitstatus
  end
end
