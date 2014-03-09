require 'formula'

class Libidn < Formula
  homepage 'http://www.gnu.org/software/libidn/'
  url 'http://ftpmirror.gnu.org/libidn/libidn-1.28.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libidn/libidn-1.28.tar.gz'
  sha256 'dd357a968449abc97c7e5fa088a4a384de57cb36564f9d4e0d898ecc6373abfb'

  bottle do
    cellar :any
    sha1 "23cb37001f1fb723b86b11717fb4df76f58934ff" => :mavericks
    sha1 "0ee166fdc8fd9a0ad245efd89323868209968235" => :mountain_lion
    sha1 "866251da871fe76c180f5b7247d4458175778313" => :lion
  end

  depends_on 'pkg-config' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp"
    system "make install"
  end

  test do
    system "#{bin}/idn", "--version"
  end
end
