class UcspiTools < Formula
  homepage "https://github.com/younix/ucspi/blob/master/README.md"
  url "https://github.com/younix/ucspi/archive/v1.2.tar.gz"
  sha1 "38a708efd6d72e0d9d077efb15477763bdea39b0"

  bottle do
    cellar :any
    sha1 "5a790193b9a08f384a7a72ea8eed55c10f5fa31e" => :yosemite
    sha1 "69c8f282e4262257481f360958abbed73d30a7b2" => :mavericks
    sha1 "b68fc07f0b4e98bfa1d0263b401d164a416bbbb7" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "ucspi-tcp"
  depends_on "libressl"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    out = shell_output("#{bin}/tlsc 2>&1", 1)
    assert_equal "tlsc [-hCH] [-c cert_file] [-f ca_file] [-p ca_path] program [args...]\n", out
  end
end
