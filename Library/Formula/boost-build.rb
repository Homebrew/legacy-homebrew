require 'formula'

class BoostBuild < Formula
  homepage 'http://boost.org/boost-build2/'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.48.0/boost_1_48_0.tar.bz2'
  md5 'd1e9a7a7f532bb031a3c175d86688d95'
  version '2011.04-svn'

  head 'http://svn.boost.org/svn/boost/trunk/tools/build/v2/', :using => :svn

  def install
    if ARGV.build_head?
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
