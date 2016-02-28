class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.7.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/debianutils/debianutils_4.7.tar.xz"
  sha256 "a269cacd40f52f2fa5d5636357714a49e8538459c16d77772efaa23711fe53d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d45be912692edddd266ce47df61d6f90f3ea3684d01e7d9da638b50b7100d5a" => :el_capitan
    sha256 "1bfeba641209396a9cae6d92540669f22e0d02504de3fe55ad03743adb125ab0" => :yosemite
    sha256 "19d7013c70729517ec148bb79690e6360c072ad55518fd64027ae73303ef8848" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    assert File.exist?(shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip)
  end
end
