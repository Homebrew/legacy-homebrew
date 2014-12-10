require "formula"

class Pastebinit < Formula
  homepage "https://launchpad.net/pastebinit"
  url "https://launchpad.net/pastebinit/trunk/1.4.1/+download/pastebinit-1.4.1.tar.gz"
  sha1 "1482311559bc939bb78bbd3e05b15400105bb9c8"

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
