class Discount < Formula
  desc "C implementation of Markdown"
  homepage "http://www.pell.portland.or.us/~orc/Code/discount/"
  url "http://www.pell.portland.or.us/~orc/Code/discount/discount-2.1.8a.tar.bz2"
  sha256 "c01502f4eedba8163dcd30c613ba5ee238a068f75291be127856261727e03526"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "51e475aa60c7f7d5125c96adc93cc00e7fce51fd21cd7eb9db6ad2e37def14d1" => :el_capitan
    sha256 "2b55cb2a180d431fcfc0d261cb852495d694e12720a845b7f38a356abd4dd809" => :yosemite
    sha256 "360be54b555218063b73b74a4530c8b573a4d2779dcc2e225816070e63e161b5" => :mavericks
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
    system "make", "install.everything"
  end
end
