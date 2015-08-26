class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "http://synthcode.com/wiki/chibi-scheme"

  stable do
    url "http://synthcode.com/scheme/chibi/chibi-scheme-0.7.3.tgz"
    sha256 "21a0cf669d42a670a11c08f50dc5aedb7b438fae892260900da58f0ed545fc7d"
  end

  head "https://github.com/ashinn/chibi-scheme.git"

  bottle do
    cellar :any
    sha256 "9fab20beb2d9afdd48d97434ca022f327f7b1eb3bec7d0a4d2ed6d44a091946a" => :yosemite
    sha256 "bcd1046b43b40256705c162d6f92f71665811120143f7857d0ba7938f20cc433" => :mavericks
    sha256 "98b0bb6559ce5b8225b481e56024dc44fcb6e4c71ece3a54a3bcbe8395d8e463" => :mountain_lion
  end

  def install
    ENV.deparallelize

    # "make" and "make install" must be done separately
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = `#{bin}/chibi-scheme -mchibi -e "(for-each write '(0 1 2 3 4 5 6 7 8 9))"`
    assert_equal "0123456789", output
    assert_equal 0, $?.exitstatus
  end
end

