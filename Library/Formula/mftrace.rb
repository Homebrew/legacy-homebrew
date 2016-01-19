class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "http://lilypond.org/mftrace/"
  url "http://lilypond.org/download/sources/mftrace/mftrace-1.2.18.tar.gz"
  sha256 "0d31065f1d35919e311d9170bbfcdacc58736e3f783311411ed1277aa09d3261"
  revision 1

  bottle do
    cellar :any
    sha256 "10296d78cdc05cb3ea41b80872868d2d4416635e2638c685e6d5a66ec2e7f7e6" => :yosemite
    sha256 "fe088c63174dfacc5fbc8e8b4a466c080e4622b6b24edc8e214e9c6dfd06dfc2" => :mavericks
    sha256 "7ced74b4d12ecf0fc13c65dd329ae081a3c53300c6efc4d9783e8f069b4fa442" => :mountain_lion
  end

  depends_on "potrace"
  depends_on "t1utils"
  depends_on "fontforge" => [:recommended, :run]

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mftrace", "--version"
  end
end
