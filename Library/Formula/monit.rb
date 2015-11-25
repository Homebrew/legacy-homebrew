class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.15.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/m/monit/monit_5.15.orig.tar.gz"
  sha256 "deada8153dc7e8755f572bc4d790143a92c7a8668dccb563ae4dbd73af56697c"

  bottle do
    cellar :any
    revision 1
    sha256 "9a399f661346e85d8e4c48e7c142c938576a99475d7655b2195f325603c9936a" => :el_capitan
    sha256 "5422a56375ac88034709bd09932faa9823753ec3faaa55497db48644ea6bde2f" => :yosemite
    sha256 "a4640c1d7b7471895e3523fe407d2f7e93364761172300f71dfcb34264de73ae" => :mavericks
    sha256 "b46c1de20298b7fbb000cefe985dc925b63e8e013459a19a3314afb57124a873" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    (share/"monit").install "monitrc"
  end

  test do
    system bin/"monit", "-c", share/"monit/monitrc", "-t"
  end
end
