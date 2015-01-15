class Rtf2html < Formula
  homepage 'http://sourceforge.net/projects/rtf2html-lite/'
  url 'https://downloads.sourceforge.net/project/rtf2html-lite/RTF%202%20HTML%20Lite%20-%20Sources/2008-10-03%2C%20first%20LGPL%20release/rtf2html-lite-20081003.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Frtf2html-lite%2Ffiles%2FRTF%25202%2520HTML%2520Lite%2520-%2520Sources%2F2008-10-03%252C%2520first%2520LGPL%2520release%2F&ts=1421347164'
  sha1 'eec3b29633f44290fcab3acd5336462cfc737140'
  version '20081003'

  def install
    system 'make'
    bin.install 'rtf2html'
  end

  test do
    test_rtf_file = (testpath/'test.rtf')
    test_rtf_file.write(nil)
    system "#{bin}/rtf2html #{test_rtf_file} #{testpath/'test.html'}"
  end
end

