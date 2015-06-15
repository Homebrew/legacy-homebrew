class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.14.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/m/monit/monit_5.14.orig.tar.gz"
  sha256 "d0424c3ee8ed43d670ba039184a972ac9f3ad6f45b0806ec17c23820996256c6"

  bottle do
    cellar :any
    sha256 "599c29599d179cd53f4f0983d1fe535aeee91b199b3d0acfd38089ae0fde94b9" => :yosemite
    sha256 "c48854b626a95aa3015877bf3aba9e77c7beb7cf0d86d5bb74894564c6c1d360" => :mavericks
    sha256 "ed2484446e8bbb5c0c5f8ce9c9559e7f181e4e7db97a19200ebcc72417b2cfe2" => :mountain_lion
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
