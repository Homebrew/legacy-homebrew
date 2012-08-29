require 'formula'

class BoostBuild < Formula
  homepage 'http://boost.org/boost-build2/'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.49.0/boost_1_49_0.tar.bz2'
  md5 '0d202cb811f934282dea64856a175698'
  version '2011.04-svn'

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
