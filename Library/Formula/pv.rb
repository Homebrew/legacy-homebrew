class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.6.0.tar.bz2"
  sha256 "0ece824e0da27b384d11d1de371f20cafac465e038041adab57fcf4b5036ef8d"

  bottle do
    sha256 "3c5bde779bd29a478548bab1fffc869516ed6cb854a09063c80ca8013f4dc400" => :yosemite
    sha256 "2268e40d7fc4ed41aad651167057d6a3e38d167678063b62b70dae226449ff7a" => :mavericks
    sha256 "f343368e557cb1c86173bd0c62143b34834e2b825b1a188ac2a37c23d0c685dd" => :mountain_lion
  end

  depends_on "gettext"

  fails_with :llvm do
    build 2334
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip
  end
end
