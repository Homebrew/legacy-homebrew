class Mkcue < Formula
  desc "Generate a CUE sheet from a CD"
  homepage "https://packages.debian.org/sid/mkcue"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz"
  version "1"
  sha256 "2aaf57da4d0f2e24329d5e952e90ec182d4aa82e4b2e025283e42370f9494867"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "7677f358f99d733a6f43d02cbf5365f3c59b4f93c6a59ee05bd48045a12cbb52" => :el_capitan
    sha256 "ddd5ad0b0a05a4fe74e0bfa18390370f547e3d21c00fa2499e50021ea3482ee4" => :yosemite
    sha256 "e8b51b15862be5637828a522e1026409c6eef947836cf787787769d7c5b8b5de" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    bin.mkpath
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system "#{bin}/mkcue", "test"
  end
end
