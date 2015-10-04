class Discount < Formula
  desc "C implementation of Markdown"
  homepage "http://www.pell.portland.or.us/~orc/Code/discount/"
  url "http://www.pell.portland.or.us/~orc/Code/discount/discount-2.1.8a.tar.bz2"
  sha256 "c01502f4eedba8163dcd30c613ba5ee238a068f75291be127856261727e03526"

  bottle do
    cellar :any
    sha256 "a803af2105ca176a4e525bd7ebbd055cb3d4d1020b9d0fa2ef3f723ffacb1f99" => :yosemite
    sha256 "2c1442bebb7543681cd076b88037c9a891dbc685ac781d6658dee3821cfbdd61" => :mavericks
    sha256 "cab7dbc460fe459181e6fa69e530a9b1d9083218449cd36a2a7a30e123f558c0" => :mountain_lion
  end

  option "with-fenced-code", "Enable Pandoc-style fenced code blocks."

  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "multimarkdown", :because => "both install `markdown` binaries"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-dl=Both
      --enable-all-features
    ]
    args << "--with-fenced-code" if build.with? "fenced-code"
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make install.everything"
  end
end
