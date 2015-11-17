class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://packages.debian.org/sid/axel"
  url "https://mirrors.kernel.org/debian/pool/main/a/axel/axel_2.4.orig.tar.gz"
  mirror "http://ftp.de.debian.org/debian/pool/main/a/axel/axel_2.4.orig.tar.gz"
  sha256 "359a57ab4e354bcb6075430d977c59d33eb3e2f1415a811948fa8ae657ca8036"

  bottle do
    sha256 "11e0633be4ae1d70e295dfc7166ce870efdfcb03cb72c6b3c9475459cf385725" => :el_capitan
    sha1 "419b8e2f1f17909363fb48307eb74f9672ceb25e" => :yosemite
    sha1 "0307ac6796e0b7e5fafac6c6085d0ba5230e50e5" => :mavericks
    sha1 "22c1e32858c443a04eaec96617773e99e036bf0b" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--debug=0", "--i18n=0"
    system "make"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert File.exist?("axel.tar.gz")
  end
end
