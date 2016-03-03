class Discount < Formula
  desc "C implementation of Markdown"
  homepage "http://www.pell.portland.or.us/~orc/Code/discount/"
  url "http://www.pell.portland.or.us/~orc/Code/discount/discount-2.2.0.tar.bz2"
  sha256 "b25395c29c2c08836199eb2eae87b56e6b545e77f5fbf921678aa1dc0ddab9f3"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "51e475aa60c7f7d5125c96adc93cc00e7fce51fd21cd7eb9db6ad2e37def14d1" => :el_capitan
    sha256 "2b55cb2a180d431fcfc0d261cb852495d694e12720a845b7f38a356abd4dd809" => :yosemite
    sha256 "360be54b555218063b73b74a4530c8b573a4d2779dcc2e225816070e63e161b5" => :mavericks
  end

  option "with-fenced-code", "Enable Pandoc-style fenced code blocks."
  option "with-shared", "Install shared library"

  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "multimarkdown", :because => "both install `markdown` binaries"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --with-dl=Both
      --enable-dl-tag
      --enable-pandoc-header
      --enable-superscript
    ]
    args << "--with-fenced-code" if build.with? "fenced-code"
    args << "--shared" if build.with? "shared"
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make", "install.everything"
  end
end
