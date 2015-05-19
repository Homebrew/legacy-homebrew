class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.13.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/m/monit/monit_5.13.orig.tar.gz"
  sha256 "9abae036f3be93a19c6b476ecd106b29d4da755bbc05f0a323e882eab6b2c5a9"

  bottle do
    cellar :any
    sha256 "ce255e89c6e847c00dcc1fd1247dc43a31cd29de103290b138426c27e446b423" => :yosemite
    sha256 "6cba93db1219233a1bec863b7466e23004cb41dd0ce20f9c753e0a6e0a887fce" => :mavericks
    sha256 "fe344102f73c8a8135c00ada216505040302e29f261becd8d22b4ad6b1dd0438" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make", "install"
    (share/"monit").install "monitrc"
  end

  test do
    system bin/"monit", "-c", share/"monit/monitrc", "-t"
  end
end
