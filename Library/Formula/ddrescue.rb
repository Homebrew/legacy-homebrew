class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "http://ftpmirror.gnu.org/ddrescue/ddrescue-1.19.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.19.tar.lz"
  sha256 "ed8d0c9d9aac80a9110e9cb0d0a91a7390d3bf9f816b67a62ca4eb140f4747b8"

  bottle do
    cellar :any
    sha1 "e3a30bbbd40b51f4ec0d71f215406e0e511f5d04" => :mavericks
    sha1 "9917eb5ba28f1acb4f02b52b9cab9cb8e7768dfc" => :mountain_lion
    sha1 "6cca70194ffc701ab511665630db71cdd46425ae" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", "/dev/null"
  end
end
