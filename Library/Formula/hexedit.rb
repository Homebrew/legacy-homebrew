class Hexedit < Formula
  desc "View and edit files in hexadecimal or ASCII"
  # Homepage/URL down since at least Jan 2016.
  homepage "http://rigaux.org/hexedit.html"
  url "http://rigaux.org/hexedit-1.2.13.src.tgz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/h/hexedit/hexedit_1.2.13.orig.tar.gz"
  sha256 "6a126da30a77f5c0b08038aa7a881d910e3b65d13767fb54c58c983963b88dd7"

  bottle do
    cellar :any
    sha256 "4fd961580544c94e94e0d8099a429d94b278cf29832c8959f1f6d6eedbe59cbf" => :yosemite
    sha256 "2c1122682c502ffb24957f6a76da4d616b72e592ae1b4f8eedf3079f143c81a9" => :mavericks
    sha256 "f6627519d855ecb6cbe3dac2b4b770ee191c4f12e001534162b3c5f2ca188ba4" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/hexedit -h 2>&1", 1)
  end
end
