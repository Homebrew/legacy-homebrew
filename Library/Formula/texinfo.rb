class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "http://ftpmirror.gnu.org/texinfo/texinfo-6.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-6.0.tar.gz"
  sha256 "83d3183290f34e7f958d209d0b20022c6fe9e921eb6fe94c27d988827d4878d2"

  bottle do
    revision 1
    sha256 "9157162006baab3069abb5d61241712f059a97c3752c1d1663e66d61062b18a5" => :el_capitan
    sha256 "9f611165b36ae3aac1b5c7a965de48659c41e53209e00a80649560414c861667" => :yosemite
    sha256 "d6031029c35ef99b7d3ef9d43daf993d6897bf73dd81cf2f53f5a6d1d38d7d73" => :mavericks
  end

  keg_only :provided_by_osx, <<-EOS.undent
    Software that uses TeX, such as lilypond and octave, require a newer version
    of these files.
  EOS

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  test do
    (testpath/"test.texinfo").write <<-EOS.undent
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match /Hello World!/, File.read("test.info")
  end
end
