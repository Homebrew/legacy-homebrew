class Libbind < Formula
  desc "Original resolver library from ISC"
  homepage "https://www.isc.org/software/libbind"
  url "https://ftp.isc.org/isc/libbind/6.0/libbind-6.0.tar.gz"
  sha256 "b98b6aa6e7c403f5a6522ffb68325785a87ea8b13377ada8ba87953a3e8cb29d"

  bottle do
    cellar :any
    revision 1
    sha256 "66bf62df254451780200c48fe1928c0e8c85bb8cda17484453f7801fafdb3460" => :yosemite
    sha256 "328505be34dca04035cb5a7efa2691c79a88bfb7d46c0d1dfc3a2b35832b3224" => :mavericks
    sha256 "8ad440bc086210b0e300667ab7c67d88128849d92a97319065d68f28efb0f359" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make" # You need to call make, before you can call make install
    system "make", "install"
  end
end
