class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  head "https://github.com/acpica/acpica.git"
  url "https://acpica.org/sites/acpica/files/acpica-unix2-20150717.tar.gz"
  sha256 "dd60f846ad8393d89d2cbadf362c6547c5e53405f5ee51097c90db3636f79e0a"

  bottle do
    cellar :any
    sha256 "6f94c02bcfde2d9bd5a947f8ecbe24030ab1a4a4951616115597314c7a4f6eac" => :yosemite
    sha256 "fbbfc9595cfeebd13587d6f5d575355cf3cb01ed7cd7b571ff1c914bca53c0a9" => :mavericks
    sha256 "575fa0f68eff7d8a515f43c5390242bdc9ca3c4bcf7f306bccc1a5f24ec254d4" => :mountain_lion
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
