class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/debianutils/debianutils_4.5.1.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/debianutils/debianutils_4.5.1.tar.xz"
  sha256 "a531c23e0105fe01cfa928457a8343a1e947e2621b3cd4d05f4e9656020c63b7"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "6dc081e6e42cdb3146c23f6e7f93ba57b20a07dc462b58e2fb7e4808db0670e7" => :el_capitan
    sha256 "3528c66e0242dba51016aa4fe90bbd60c32c65cbde95d638bb441cc297f8d5bc" => :yosemite
    sha256 "b3d0a5fdaa0d85c723360c8c1cb9bccb7c67eaff3cf7636f20c7560a3bbf4f10" => :mavericks
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
