class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "http://dev.yorhel.nl/ncdu"
  url "http://dev.yorhel.nl/download/ncdu-1.11.tar.gz"
  sha256 "d0aea772e47463c281007f279a9041252155a2b2349b18adb9055075e141bb7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "80a08ad611074e281acd50bec632af4b0b9cfef7fd195daaa7b2c73bc4627066" => :el_capitan
    sha256 "dc534326b331cfaaead5fb152f0ef084bc29884d84cfcd91df151caa45a735c8" => :yosemite
    sha256 "7b7741df3ddbe01184b0965ed2f4ef37216ba12276dc32620c30e799369ffe87" => :mavericks
    sha256 "c678a0c167c84de103569e6625f52605afa64dfe5878c8410e2c0c99e6ba6b7e" => :mountain_lion
  end

  head do
    url "git://g.blicky.net/ncdu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
  end
end
