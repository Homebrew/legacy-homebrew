require 'formula'

class BoostBuild < Formula
  homepage 'http://boost.org/boost-build2/'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.53.0/boost_1_53_0.tar.bz2'
  sha1 'e6dd1b62ceed0a51add3dda6f3fc3ce0f636a7f3'
  version '2011.12-svn'

  head 'http://svn.boost.org/svn/boost/trunk/tools/build/v2/'

  def install
    if build.head?
      system "./bootstrap.sh"
      system "./b2", "--prefix=#{prefix}", "install"
    else
      cd 'tools/build/v2' do
        system "./bootstrap.sh"
        system "./b2", "--prefix=#{prefix}", "install"
      end
    end
  end
end
