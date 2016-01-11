class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://packages.debian.org/sid/axel"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/axel/axel_2.4.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/axel/axel_2.4.orig.tar.gz"
  sha256 "359a57ab4e354bcb6075430d977c59d33eb3e2f1415a811948fa8ae657ca8036"

  bottle do
    revision 1
    sha256 "0a5c877bb143d08c037650f78b29d174a83761859e27dcf097e11f8911ad8dfc" => :el_capitan
    sha256 "a6adc5c5853d2ec103c090121e0c1cf9fe25726f64421633fee016fd257fc95d" => :yosemite
    sha256 "4b4060a479c5a3920fa38989ac0103eb0077e4a210140fd930fac304b44a0762" => :mavericks
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
