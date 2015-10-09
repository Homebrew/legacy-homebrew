class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "http://synthcode.com/wiki/chibi-scheme"
  head "https://github.com/ashinn/chibi-scheme.git"

  stable do
    url "http://synthcode.com/scheme/chibi/chibi-scheme-0.7.3.tgz"
    sha256 "21a0cf669d42a670a11c08f50dc5aedb7b438fae892260900da58f0ed545fc7d"
  end

  bottle do
    cellar :any
    revision 1
    sha256 "b3f470a3d3000eb8d1d8ff2f94a68f03678f78e852db513df7aa446cacf5f2a2" => :el_capitan
    sha256 "6d03409ae6925139c07eb58b7cf310e98cca5465cb0d41dfb41300ed24b584ee" => :yosemite
    sha256 "eccb3f2e0229c542edb4f15d985b6ce231bb6ae223d6b117e085f3217dc8652c" => :mavericks
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
