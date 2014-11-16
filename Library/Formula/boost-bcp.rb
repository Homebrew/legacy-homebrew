require 'formula'

class BoostBcp < Formula
  homepage 'http://www.boost.org/doc/tools/bcp/'
  url 'https://downloads.sourceforge.net/project/boost/boost/1.56.0/boost_1_56_0.tar.bz2'
  sha1 'f94bb008900ed5ba1994a1072140590784b9b5df'

  head 'http://svn.boost.org/svn/boost/trunk/'

  depends_on 'boost-build' => :build

  def install
    cd 'tools/bcp' do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end
end
