class Ht < Formula
  desc "Viewer/editor/analyzer for executables"
  homepage "http://hte.sf.net/"
  url "https://downloads.sourceforge.net/project/hte/ht-source/ht-2.1.0.tar.bz2"
  sha256 "31f5e8e2ca7f85d40bb18ef518bf1a105a6f602918a0755bc649f3f407b75d70"

  bottle do
    cellar :any
    sha1 "0091273a3a0bcdeddc2a4604ffd274db4d8a6e0d" => :yosemite
    sha1 "60349a8bb48c045ef6d9a9056ac2d975af1917cf" => :mavericks
    sha1 "1e862ab300b0e5a417d96d628a7d2163865bcce9" => :mountain_lion
  end

  depends_on "lzo"

  def install
    chmod 0755, "./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make", "install"
  end

  test do
    assert_match "ht #{version}", shell_output("#{bin}/ht -v")
  end
end
