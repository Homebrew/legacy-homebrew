class Abcde < Formula
  desc "Better CD Encoder"
  homepage "http://abcde.einval.com"
  url "http://abcde.einval.com/download/abcde-2.7.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/abcde/abcde_2.7.orig.tar.gz"
  sha256 "0148698a09fedcbae37ee9da295afe411a1190cf8ae224b7814d31b5bf737746"
  head "http://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8eb62fee6347c03f27d4999395c767ac7436f9c032547da45c6b08d84f01a6b3" => :el_capitan
    sha256 "6d4f26fde607164987e2db970d461980204993e9998f262aa18129c0129ae4ef" => :yosemite
    sha256 "243f8ae6d987901524e82790f4e89687795d52c6b4f5d9a20cfec4ae38a9f462" => :mavericks
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
