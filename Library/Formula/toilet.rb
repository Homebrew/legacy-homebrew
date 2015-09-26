class Toilet < Formula
  desc "Color-based alternative to figlet (uses libcaca)"
  homepage "http://caca.zoy.org/wiki/toilet"
  url "http://caca.zoy.org/raw-attachment/wiki/toilet/toilet-0.3.tar.gz"
  sha256 "89d4b530c394313cc3f3a4e07a7394fa82a6091f44df44dfcd0ebcb3300a81de"

  depends_on "pkg-config" => :build
  depends_on "libcaca"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/toilet", "--version"
  end
end
