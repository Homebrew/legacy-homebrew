require 'formula'

class BoostBcp < Formula
  homepage 'http://www.boost.org/doc/tools/bcp/'
  url 'https://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.bz2'
  sha1 'cef9a0cc7084b1d639e06cd3bc34e4251524c840'

  head 'http://svn.boost.org/svn/boost/trunk/'

  depends_on 'boost-build' => :build

  def install
    cd 'tools/bcp' do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end
end
