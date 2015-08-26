class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  head "https://github.com/acpica/acpica.git"
  url "https://acpica.org/sites/acpica/files/acpica-unix2-20150717.tar.gz"
  sha256 "dd60f846ad8393d89d2cbadf362c6547c5e53405f5ee51097c90db3636f79e0a"

  bottle do
    cellar :any
    sha256 "7fbe5d6e05d227b549b50469b6bc33713fbc82781db6c9491069667393e2b135" => :yosemite
    sha256 "a484e1f4d6750e2a99ccba5680696da9f3bca0dbe47053bc37e609100afb3db3" => :mavericks
    sha256 "5fcda590ea6dca0191e58604eedb6a03318964adf175502e56eda34174295628" => :mountain_lion
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
