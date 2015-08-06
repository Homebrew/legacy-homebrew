class Abcde < Formula
  desc "Better CD Encoder"
  homepage "http://abcde.einval.com"
  url "http://abcde.einval.com/download/abcde-2.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/a/abcde/abcde_2.7.orig.tar.gz"
  sha256 "0148698a09fedcbae37ee9da295afe411a1190cf8ae224b7814d31b5bf737746"
  head "http://git.einval.com/git/abcde.git"

  bottle do
    cellar :any
    sha256 "e290c7b2658678e4a10f6a717805e06478c1466b424e9d6589929dd9175f994d" => :yosemite
    sha256 "1f140fb80601a5b8376b83c5502a2c7c89df42be42a814b02d40f6bfb8ee50a8" => :mavericks
    sha256 "e7f32cb2199c87c28f24c6d23e6f577d0d7d16f8880f56c8c5b1635e3772f3e4" => :mountain_lion
  end

  depends_on "cd-discid"
  depends_on "cdrtools"
  depends_on "id3v2"
  depends_on "mkcue"
  depends_on "flac" => :optional
  depends_on "lame" => :optional
  depends_on "vorbis-tools" => :optional

  def install
    system "make", "install", "prefix=#{prefix}", "etcdir=#{etc}"
  end

  test do
    system "#{bin}/abcde", "-v"
  end
end
