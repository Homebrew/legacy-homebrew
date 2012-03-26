require 'formula'

class Stegdetect < Formula
  url 'http://www.outguess.org/stegdetect-0.6.tar.gz'
  homepage 'http://www.outguess.org'
  md5 '850a3551b5c450b9f450a919ad021767'

  def patches
    "https://raw.github.com/gist/1467161/da367fc11b298ec1c07e7c91646d0e34a5b4834c/stegdetect-0.6.patch"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{prefix}/share/man"
    inreplace "jpeg-6b/Makefile", "install:", "_install:"
    system "make"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test stegdetect`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
