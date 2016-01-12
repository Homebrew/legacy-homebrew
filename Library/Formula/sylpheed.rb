class Sylpheed < Formula
  desc "A simple, lightweight email-client"
  homepage "http://sylpheed.sraoss.jp/en/"
  url "http://sylpheed.sraoss.jp/sylpheed/v3.4/sylpheed-3.4.2.tar.gz"
  sha256 "a4c47b570a5b565d14ff9933cf2e03fcb895034c1f072f9cd2c4a9867a2f2263"
  revision 1

  bottle do
    sha256 "b6a927472d5bd384cf91452a75dcb0557ec2abeed89e979416d21907526a601b" => :yosemite
    sha256 "8bc89499181ff389fd5df487ec24586e07e4675c046e2b4c4946fc257fe04dff" => :mavericks
    sha256 "7d8619462ea45f715347951aaec3ac6bcdb793897a625bf6a6c8ec7455fae5b5" => :mountain_lion
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
