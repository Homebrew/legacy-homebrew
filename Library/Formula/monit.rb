class Monit < Formula
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.12.tar.gz"
  sha256 "43075396203569f87b67f7bffd1de739aa2fba302956237a2b0dc7aaf62da343"

  bottle do
    cellar :any
    sha256 "b6ade6465692c0faed5f1068e42429a50f94f2a7b2a275d43233261f2924bbb7" => :yosemite
    sha256 "cffb9f23a45afe401f5965bc9611cf64a15444eb142e216aae243bb8d82021de" => :mavericks
    sha256 "70e825e0e6215aa7bf6a4897b03a0552259f8b739b68332815f18508b7188bf0" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make install"
  end

  test do
    system "#{bin}/monit", "-h"
  end
end
