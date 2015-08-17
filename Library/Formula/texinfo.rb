class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "http://ftpmirror.gnu.org/texinfo/texinfo-6.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-6.0.tar.gz"
  sha256 "83d3183290f34e7f958d209d0b20022c6fe9e921eb6fe94c27d988827d4878d2"

  bottle do
    sha256 "4bd78f0303130865e121263b7d7809a69816b30697da412b9c7101b4bf62cfaa" => :yosemite
    sha256 "e976cec2aacc4a2754058dc54145e8aba61444bd01c5573a79b4a1912f4cda1a" => :mavericks
    sha256 "c9ee6147bbc2c1a21b65fb4f2df220b811c1144e58d1ce53ad94e7dffd6633e8" => :mountain_lion
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
