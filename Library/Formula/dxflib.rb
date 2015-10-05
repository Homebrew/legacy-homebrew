class Dxflib < Formula
  desc "C++ library for parsing DXF files"
  homepage "http://www.ribbonsoft.com/en/what-is-dxflib"
  url "http://www.ribbonsoft.com/archives/dxflib/dxflib-2.5.0.0-1.src.tar.gz"
  sha256 "20ad9991eec6b0f7a3cc7c500c044481a32110cdc01b65efa7b20d5ff9caefa9"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "ba2cbde3c7ba4183e5d44325791632bdb3aa3570bfbdd4b731596144cddd4881" => :el_capitan
    sha1 "58c0add8f6f8c5211ca4e59bc185468531431765" => :yosemite
    sha1 "2184e3835e92a57a52854ad82f966a9e186c30e0" => :mavericks
    sha1 "238319c0040cde6d76fa085f086adef65c3c15f0" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
