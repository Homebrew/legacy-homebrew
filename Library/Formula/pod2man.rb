class Pod2man < Formula
  desc "perl documentation generator"
  homepage "http://www.eyrie.org/~eagle/software/podlators/"
  url "http://archives.eyrie.org/software/perl/podlators-4.03.tar.xz"
  sha256 "4694326b35f569dafc4226398b25d5c82c86ed485039effdeb4f14c2ae5b7032"

  keg_only :provided_by_osx

  def install
    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"

    # makefile installs manpages into a root man directory
    share.install prefix/"man"
  end

  test do
    (testpath/"test.pod").write "=head2 Test heading\n"
    manpage = shell_output("#{bin}/pod2man #{testpath}/test.pod")
    assert_match '.SS "Test heading"', manpage
  end
end
