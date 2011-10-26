require 'formula'

class Rc < Formula
  url 'ftp://rc.quanstro.net/pub/rc-1.7.2.tgz'
  homepage 'http://doc.cat-v.org/plan_9/4th_edition/papers/rc'
  md5 '4a85e4b4e3a0a5d3803109c5b2dce710'

  def install
    system "./configure","--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test rc`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
