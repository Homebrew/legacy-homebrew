class Abcde < Formula
  desc "Better CD Encoder"
  homepage "http://abcde.einval.com"
  url "http://abcde.einval.com/download/abcde-2.7.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/abcde/abcde_2.7.1.orig.tar.gz"
  sha256 "3401e39785b20edee843d4d875b47d2b559f764681c482c4491a8c8ba605f250"
  head "http://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "280d8fb0d65538b2fc048f1bd04bde8e613debf0ce11ff1920965f584733d1a7" => :el_capitan
    sha256 "07e438a74a135cfb7edb8c4e111f584d16d66a7d9a1479261e91ff53a25ce6ec" => :yosemite
    sha256 "27fda1409d19f6f34fa4f4de866ba9da564873139f21b74edf3e0494a647097d" => :mavericks
  end

  depends_on "cd-discid"
  depends_on "cdrtools"
  depends_on "id3v2"
  depends_on "mkcue"
  depends_on "flac" => :optional
  depends_on "lame" => :optional
  depends_on "vorbis-tools" => :optional
  depends_on "glyr" => :optional

  def install
    system "make", "install", "prefix=#{prefix}", "etcdir=#{etc}"
  end

  test do
    system "#{bin}/abcde", "-v"
  end
end
