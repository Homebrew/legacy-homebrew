require 'formula'

class BoostBuildV2 < Formula
  url 'http://downloads.sourceforge.net/boost/boost-build-2.0-m12.tar.bz2'
  homepage 'http://www.boost.org/boost-build2/'
  head 'https://svn.boost.org/svn/boost/trunk/tools/build/v2/'
  md5 '38a40f1c0c2d6eb4f14aa4cf52e9236a'

  def install
    rm_rf [ './debian', './jam_src' ]

    (share+'boost-build').install Dir['*']
  end
end
