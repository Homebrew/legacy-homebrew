class PfileUtils < Formula
  desc "Collection of utilities for manipulating PFiles (ICSI feature file)"
  homepage "http://www1.icsi.berkeley.edu/Speech/qn.html"

  url "https://github.com/Marvin182/pfile-utilities/archive/v0.51.tar.gz"
  sha256 "151bb83af1c06a7168908d8440ebb15f880de360d7f292f41716fa84b520301a"
  head "https://github.com/Marvin182/pfile-utilities.git"

  depends_on "quicknet"
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    # Create a simple pfile
    (testpath/"data.txt").write <<-EOS.undent
      0 0 0 0 0
      0 1 0 1 1
      0 2 1 0 1
      0 3 1 1 0
    EOS
    system "#{bin}/pfile_create", "-f", "2", "-l", "1", "-i", "data.txt", "-o", testpath/"data.pfile"
    # Check if it worked
    assert_equal "data.pfile\n1 sentences, 4 frames, 1 label(s), 2 features\n", `pfile_info data.pfile`
    assert_equal "Processing sentence 0\n0 0 0 0 0\n0 1 0 1 1\n0 2 1 0 1\n0 3 1 1 0\n", `pfile_print -i data.pfile`
  end
end
