class Uni2ascii < Formula
  desc "Bi-directional conversion between UTF-8 and various ASCII flavors"
  # homepage/url: "the website you are looking for is suspended"
  # Switched to Debian mirrors June 2015.
  homepage "http://billposer.org/Software/uni2ascii.html"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/u/uni2ascii/uni2ascii_4.18.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/u/uni2ascii/uni2ascii_4.18.orig.tar.gz"
  sha256 "9e24bb6eb2ced0a2945e2dabed5e20c419229a8bf9281c3127fa5993bfa5930e"

  bottle do
    cellar :any
    sha256 "0200efd85e37c8c6e2582f82ff8fbb050bba07d31a1bf3720837f5d30da6a54b" => :yosemite
    sha256 "b58b9d744048c9e2cc81e75d46c94926d14b2c25a613a05cd0835882221ade7c" => :mavericks
    sha256 "fe16b41d049b9dada88474ace55d1155b70afe7b679d323772743a86ec24cb64" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    ENV["MKDIRPROG"]="mkdir -p"
    system "make", "install"
  end

  test do
    # uni2ascii
    assert_equal "0x00E9", pipe_output("#{bin}/uni2ascii -q", "é")

    # ascii2uni
    assert_equal "e\n", pipe_output("#{bin}/ascii2uni -q", "0x65")
  end
end
