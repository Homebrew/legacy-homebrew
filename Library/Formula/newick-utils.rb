require 'formula'

class NewickUtils < Formula
  url 'http://cegg.unige.ch/pub/newick-utils-1.5.0.tar.gz'
  homepage 'http://cegg.unige.ch/newick_utils'
  md5 '5f65b0fe30bf9389297616358f01fac7'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test newick-utils`. Remove this comment before submitting
    # your pull request!
    system "make check"
  end
end
