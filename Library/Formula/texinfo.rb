class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "http://ftpmirror.gnu.org/texinfo/texinfo-5.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-5.2.tar.gz"
  sha256 "6b8ca30e9b6f093b54fe04439e5545e564c63698a806a48065c0bba16994cf74"

  bottle do
    revision 1
    sha256 "c32217fe9d506df49481730dd580a9207931a13c4e0ade3e9caaf83feeaeaba7" => :yosemite
    sha256 "84d4e2ff689f10d2a68bdd42ccf0726306e74314378d2dd2c78e52fe58945dd3" => :mavericks
    sha256 "73e86c31e3ae5a971e8bc4f5a5f2823a2f3858ee166f5cdd2cf11a4ac7036728" => :mountain_lion
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
