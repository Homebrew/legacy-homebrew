require "formula"

class Gptfdisk < Formula
  homepage "http://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/0.8.10/gptfdisk-0.8.10.tar.gz"
  sha1 "1708e232220236b6bdf299b315e9bc2205c01ba5"
  revision 2

  bottle do
    cellar :any
    sha1 "72d74146ed1e0c057dff5afd70d55d4ec5992484" => :mavericks
    sha1 "b3c218e0f18ce1a286f1a70823d08f349a6342e5" => :mountain_lion
    sha1 "6ca48618e6a5a5800b192c06107f9bcc1b499e3a" => :lion
  end

  depends_on "popt"
  depends_on "icu4c"

  def install
    system "make -f Makefile.mac"
    sbin.install "gdisk", "cgdisk", "sgdisk", "fixparts"
    man8.install Dir["*.8"]
  end

  test do
    assert_match /GPT fdisk \(gdisk\) version #{Regexp.escape(version)}/,
                 pipe_output("#{sbin}/gdisk", "\n")
  end
end
