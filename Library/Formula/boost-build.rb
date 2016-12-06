require 'formula'

class BoostBuild < Formula
  url 'http://downloads.sourceforge.net/project/boost/boost/1.48.0/boost_1_48_0.tar.bz2'
  md5 'd1e9a7a7f532bb031a3c175d86688d95'
  head 'http://svn.boost.org/svn/boost/trunk/tools/build/v2/', :using => :svn
  version '2011.04-svn'
  homepage 'http://boost.org/boost-build2/'

  def install
    if ARGV.build_head?
      system "./bootstrap.sh"
      system "./b2", "--prefix=#{prefix}", "install"
    else
      Dir.chdir("tools/build/v2") do
        system "./bootstrap.sh"
        system "./b2", "--prefix=#{prefix}", "install"
      end
    end
  end

  def caveats
    return "This formula conflicts with Boost.Jam"
  end
end
