class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "http://ftpmirror.gnu.org/ddrescue/ddrescue-1.20.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.20.tar.lz"
  sha256 "83f993b1a167865d76e92e7c1406436331a8b3b337b9868fd6ca1ec2c45460bd"

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
