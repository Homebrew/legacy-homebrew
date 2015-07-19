class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "http://ftpmirror.gnu.org/texinfo/texinfo-5.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-5.2.tar.gz"
  sha256 "6b8ca30e9b6f093b54fe04439e5545e564c63698a806a48065c0bba16994cf74"

  bottle do
    sha1 "988fc8c195a43ad8b9dea1da2827fb24c794c200" => :yosemite
    sha1 "40453ac408ede2cb5470935a5c5d2360f64032b5" => :mavericks
    sha1 "1ac4d9ac120248a5b71cb45199c01bad850a7655" => :mountain_lion
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
