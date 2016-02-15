class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "http://ftpmirror.gnu.org/rcs/rcs-5.9.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/rcs/rcs-5.9.4.tar.xz"
  sha256 "063d5a0d7da1821754b80c639cdae2c82b535c8ff4131f75dc7bbf0cd63a5dff"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "78f1d531b800653dde89794a55e92ba4cf367084c9ce5dd31da7aaf4b7785dac" => :el_capitan
    sha256 "81c6feabf9806d1912e553809a73e9c531607e0281613f940fbc6dc8e47a5ede" => :yosemite
    sha256 "5eae8b3cb0c8b9aef306811d6fb62a9eef0350bfa2f01f398b60fa13cae00b79" => :mavericks
  end

  # Fixes use of _Noreturn attribute
  # This patch is a commit from the upstream git repo; will be in the next release.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/3fff7c990b8df4174045834b9c1210e7736ff5a4/rcs/noreturn.patch"
    sha256 "ac2f5ad1df932361e19c6184d2dfddfbe7664184ac4c24a3224c85707cd4da9f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
