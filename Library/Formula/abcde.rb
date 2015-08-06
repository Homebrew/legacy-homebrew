class Abcde < Formula
  desc "Better CD Encoder"
  homepage "http://abcde.einval.com"
  url "http://abcde.einval.com/download/abcde-2.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/a/abcde/abcde_2.7.orig.tar.gz"
  sha256 "0148698a09fedcbae37ee9da295afe411a1190cf8ae224b7814d31b5bf737746"
  head "http://git.einval.com/git/abcde.git"

  bottle do
    cellar :any
    sha1 "fb1aa6a4cb064c1b6d26ab87f7b7eb1a61388963" => :yosemite
    sha1 "4fd607f7adef90f95d47dae5e1ae43bdbbd3c543" => :mavericks
    sha1 "b98cc145bbbae45421b36721f39f0a5a7a8ee3f7" => :mountain_lion
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
