require 'formula'

class LibewfBeta < Formula
  url 'http://downloads.sourceforge.net/project/libewf/libewf2-beta/libewf-beta-20111015/libewf-beta-20111015.tar.gz'
  homepage 'http://sourceforge.net/projects/libewf'
  md5 '2d3d45016bb8867a1daa5a5abafa6445'

  def install
    ENV['LIBTOOLIZE'] = "/usr/bin/glibtoolize"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test libewf-beta`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
