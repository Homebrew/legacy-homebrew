class Gptfdisk < Formula
  homepage "http://www.rodsbooks.com/gdisk/"
  url "https://downloads.sourceforge.net/project/gptfdisk/gptfdisk/1.0.0/gptfdisk-1.0.0.tar.gz"
  sha256 "5b66956743a799fc0471cdb032665c1391e82f9c5b3f1d7d726d29fe2ba01d6c"

  bottle do
    cellar :any
    sha1 "a4db6095a887342b21583eca37e639afb6bc2d30" => :mavericks
    sha1 "15c7a03013725b422771f26ad077c2060d4fea2a" => :mountain_lion
    sha1 "174a1a62488be645d1c4f045456f94962c92e02c" => :lion
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
