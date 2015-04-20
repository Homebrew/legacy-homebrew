class Gptfdisk < Formula
  homepage "http://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.0/gptfdisk-1.0.0.tar.gz"
  sha256 "5b66956743a799fc0471cdb032665c1391e82f9c5b3f1d7d726d29fe2ba01d6c"

  bottle do
    cellar :any
    sha256 "13ca80c78f1af57f910e52c1a1e67b4136de5265641d9f6f7b0eed8cf823ef6b" => :yosemite
    sha256 "feae65211e8ae2ec11c53a457c544514fada5e860554bd9442a50607cedf6492" => :mavericks
    sha256 "a1745d4d039a04b10e281777e8bfbdbea7a50ee1c7244aa8e069f46bf71191c3" => :mountain_lion
  end

  depends_on "popt"
  depends_on "icu4c"

  def install
    system "make", "-f", "Makefile.mac"
    sbin.install "gdisk", "cgdisk", "sgdisk", "fixparts"
    man8.install Dir["*.8"]
  end

  test do
    assert_match /GPT fdisk \(gdisk\) version #{Regexp.escape(version)}/,
                 pipe_output("#{sbin}/gdisk", "\n")
  end
end
