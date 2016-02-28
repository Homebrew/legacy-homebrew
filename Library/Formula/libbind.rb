class Libbind < Formula
  desc "Original resolver library from ISC"
  homepage "https://www.isc.org/software/libbind"
  url "https://ftp.isc.org/isc/libbind/6.0/libbind-6.0.tar.gz"
  sha256 "b98b6aa6e7c403f5a6522ffb68325785a87ea8b13377ada8ba87953a3e8cb29d"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "d0a71d129904ac0529c6f8e789a41307caaeb0e6d9f33f30f23f4b3dbc61456d" => :el_capitan
    sha256 "c2eaf992dc37ce98d5936ba7e086c30a5da242bfe834e593dfb40d7d3e546923" => :yosemite
    sha256 "f59cf59e14f6192c962592a4411391413d929c8dfff81fdd8b4a82ce7c0d3f02" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make" # You need to call make, before you can call make install
    system "make", "install"
  end
end
