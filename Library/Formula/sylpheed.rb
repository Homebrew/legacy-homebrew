class Sylpheed < Formula
  desc "A simple, lightweight email-client"
  homepage "http://sylpheed.sraoss.jp/en/"
  url "http://sylpheed.sraoss.jp/sylpheed/v3.4/sylpheed-3.4.2.tar.gz"
  sha256 "a4c47b570a5b565d14ff9933cf2e03fcb895034c1f072f9cd2c4a9867a2f2263"
  revision 1

  bottle do
    sha256 "b59386d9e5153d9bcd8f68410196de3d8715d227dda7321513c10893bf517773" => :el_capitan
    sha256 "f2fb3d3d1ef07736d61389f2c645d8b0c4e163f46330f432090a71577059207d" => :yosemite
    sha256 "f530d16dae124a799ec458456c62499801a3f150848602783a994466fb62c087" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-updatecheck"
    system "make", "install"
  end

  test do
    system "#{bin}/sylpheed", "--version"
  end
end
