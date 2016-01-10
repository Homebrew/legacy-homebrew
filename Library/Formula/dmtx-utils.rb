class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "http://www.libdmtx.org"
  url "https://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/dmtx-utils-0.7.4.zip"
  sha256 "4e8be16972320a64351ab8d57f3a65873a1c35135666a9ce5fd574b8dc52078f"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "libdmtx"
  depends_on "imagemagick"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
