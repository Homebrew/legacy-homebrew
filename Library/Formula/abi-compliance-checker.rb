class AbiComplianceChecker < Formula
  desc "Check binary and source compatibility for C/C++"
  homepage "http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
  url "https://github.com/lvc/abi-compliance-checker/archive/1.99.16.tar.gz"
  sha256 "e1ecfbe5f97f00ed0858cb33391b0b04be78dff02a052c90bb5eb3ee4fb8cf49"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef2fbf8ea0c8aa09b2423fc780c640c4355cddbd4d53f51fd91e1adb92d84bbf" => :el_capitan
    sha256 "a29fe7fcd7447ee760d921558656ce0960f3d7b55a004cd121f21453d0c772f4" => :yosemite
    sha256 "9c46d9948a2905be8cb65d730c26208f4d09225a005ea0743f425065f6eb88f9" => :mavericks
  end

  depends_on "ctags"
  depends_on "gcc" => :run

  def install
    system "perl", "Makefile.pl", "-install", "--prefix=#{prefix}"
    rm bin/"abi-compliance-checker.cmd"
  end

  test do
    (testpath/"test.xml").write <<-EOS.undent
      <version>1.0</version>
      <headers>#{Formula["ctags"].include}</headers>
      <libs>#{Formula["ctags"].lib}</libs>
    EOS
    gcc_suffix = Formula["gcc"].version.to_s.slice(/\d+/)
    system bin/"abi-compliance-checker", "-cross-gcc", "gcc-" + gcc_suffix,
                                         "-lib", "ctags",
                                         "-old", testpath/"test.xml",
                                         "-new", testpath/"test.xml"
  end
end
