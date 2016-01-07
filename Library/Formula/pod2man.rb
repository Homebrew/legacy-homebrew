class Pod2man < Formula
  desc "perl documentation generator"
  homepage "http://www.eyrie.org/~eagle/software/podlators/"
  url "http://archives.eyrie.org/software/ARCHIVE/podlators/podlators-4.03.tar.xz"
  sha256 "4694326b35f569dafc4226398b25d5c82c86ed485039effdeb4f14c2ae5b7032"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc054b30603815cb2bb3aec5df885e16a7d93cf8140c11ded05e9ac781d25580" => :el_capitan
    sha256 "45c095c3b709ff0588930c34749fe6990d5f73067f46140892774b14049539de" => :yosemite
    sha256 "9e937ed310b36a4e587ae769a0237a2e2948eabbfe7c21dba00ca894084ef82a" => :mavericks
  end

  keg_only :provided_by_osx

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.pod").write "=head2 Test heading\n"
    manpage = shell_output("#{bin}/pod2man #{testpath}/test.pod")
    assert_match '.SS "Test heading"', manpage
  end
end
