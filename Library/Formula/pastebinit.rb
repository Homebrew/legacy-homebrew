class Pastebinit < Formula
  desc "Send things to pastebin from the command-line"
  homepage "https://launchpad.net/pastebinit"
  url "https://launchpad.net/pastebinit/trunk/1.4.1/+download/pastebinit-1.4.1.tar.gz"
  sha256 "39e3dcb98d2aa9d65f86c648c375ca75fa312fc773e568963e9aefffea0c9bf7"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "19a89cc21076e0f0c48e2c355ef07420255938bb1170c28c5cac26924c619e25" => :yosemite
    sha256 "691f4cf7eb32ea56ef0ea02f9f0a68660147236c7abcf3e06669779a0f1033a4" => :mavericks
  end

  depends_on "python3"
  depends_on "docbook2x" => :build

  def install
    inreplace "pastebinit", "/usr/bin/python3", Formula["python3"].opt_bin + "python3"
    inreplace "pastebinit", "/usr/local/etc/pastebin.d", etc + "pastebin.d"
    system "docbook2man", "pastebinit.xml"
    bin.install "pastebinit"
    etc.install "pastebin.d"
    man1.install "PASTEBINIT.1" => "pastebinit.1"
    libexec.install "po", "utils"
  end

  test do
    system "date | pastebinit"
  end
end
