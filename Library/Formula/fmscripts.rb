require 'formula'

class Fmscripts < Formula
  url 'http://www.defraine.net/~brunod/fmdiff/fmscripts-20110714.tar.gz'
  homepage 'http://soft.vub.ac.be/soft/'
  md5 '54b5ed94c89acd309effd37187414593'

  # depends_on 'cmake' => :build

  def install
    system "make"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test fmscripts`. Remove this comment before submitting
    # your pull request!
    system "fmdiff"
  end
end
