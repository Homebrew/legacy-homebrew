class Pod2man < Formula
  desc "perl documentation generator"
  homepage "http://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.06.tar.xz"
  sha256 "11c7b32a8f5d32e28c732927f337697174d6c31714acbdc39c2dd24b0b9e5a21"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0ae6f201d4771a6539be2026226528f3dba5c4321a73a59ed05971725ab9759" => :el_capitan
    sha256 "8806729aca1eafefe388f2553d11e97087f5272271f11861c6b5ce2f8782acfa" => :yosemite
    sha256 "72b70d3540fbbe10b8afa8e4ac366075a45947b340576d0d0ec66f218363100a" => :mavericks
  end

  keg_only :provided_by_osx

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}",
                   "INSTALLSCRIPT=#{bin}",
                   "INSTALLMAN1DIR=#{man1}", "INSTALLMAN3DIR=#{man3}"
    system "make", "install"
  end

  test do
    (testpath/"test.pod").write "=head2 Test heading\n"
    manpage = shell_output("#{bin}/pod2man #{testpath}/test.pod")
    assert_match '.SS "Test heading"', manpage
  end
end
