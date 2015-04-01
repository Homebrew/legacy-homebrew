class ChibiScheme < Formula
  homepage "https://github.com/ashinn/chibi-scheme"
  url "http://abrek.synthcode.com/chibi-scheme-0.7.2.tgz"
  sha256 "bae56b5a6ce2d90dc334a5a81de027d9cdc1c563ceddd8e0bf6276b2da13d340"

  head "https://github.com/ashinn/chibi-scheme.git"

  bottle do
    cellar :any
    sha1 "eff7f6bd5b2a711cd21b7c6d74d14462b647b4ad" => :yosemite
    sha1 "2343e7d9a49a5ea997cbe5e7f91e516aeaf2cbfb" => :mavericks
    sha1 "55723f46b0c3043f676db51894a47e9ac8271b47" => :mountain_lion
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
