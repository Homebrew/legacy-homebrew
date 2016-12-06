require 'formula'

class Pdf417Enc < Formula
  homepage ''
  url 'http://sourceforge.net/projects/pdf417encode/files/pdf417encode/pdf417_enc.4.4/pdf417_enc.4.4.tar.gz/download'
  md5 'ae6ebd0b48d4d910fd498af753665661'

  depends_on 'giflib'

  def install
    inreplace 'Makefile', /^UNAME = Linux/, '#UNAME = Linux'
    inreplace 'Makefile', /#UNAME = FreeBSD/, 'UNAME = FreeBSD'
    system "make clean"
    system "make"
    bin.install 'pdf417_enc'
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test pdf417_enc`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
