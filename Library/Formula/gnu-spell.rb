class GnuSpell < Formula
  desc "Unix spell emulator"
  homepage "https://savannah.gnu.org/projects/spell/"
  url "http://ftpmirror.gnu.org/spell/spell-1.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/spell/spell-1.1.tar.gz"
  sha256 "7cc243547eb31360ff769835dc88b5ba4f2f47385daa230523beecf9e1c29744"

  depends_on "coreutils" => :build
  depends_on "ispell"

  def install
    inreplace "Makefile.in", "$(prefix)/info", "@infodir@"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--infodir=#{info}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "BOTHE", pipe_output("#{bin}/spell", "BOTHE BOTHER").chomp
  end
end
