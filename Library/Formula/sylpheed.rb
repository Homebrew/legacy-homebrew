class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "http://sylpheed.sraoss.jp/en/"
  url "http://sylpheed.sraoss.jp/sylpheed/v3.5/sylpheed-3.5.0.tar.bz2"
  sha256 "4a0b62d17bca6f1a96ab951ef55a9a67813d87bc1dc3ee55d8ec2c045366a05c"

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
