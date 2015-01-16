class Rtf2html < Formula
  homepage "http://sourceforge.net/projects/rtf2html-lite/"
  url "https://downloads.sourceforge.net/project/rtf2html-lite/RTF%202%20HTML%20Lite%20-%20Sources/2008-10-03%2C%20first%20LGPL%20release/rtf2html-lite-20081003.tar.bz2"
  sha1 "eec3b29633f44290fcab3acd5336462cfc737140"

  def install
    system "make"
    bin.install "rtf2html"
  end

  test do
    test_rtf_file = testpath/"test.rtf"
    touch test_rtf_file
    system bin/"rtf2html", test_rtf_file, testpath/"test.html"
  end
end
