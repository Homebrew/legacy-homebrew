require 'formula'

class BoostBcp < Formula
  homepage 'http://www.boost.org/doc/tools/bcp/'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.53.0/boost_1_53_0.tar.bz2'
  version '2013.06-svn'
  sha1 'e6dd1b62ceed0a51add3dda6f3fc3ce0f636a7f3'

  head 'http://svn.boost.org/svn/boost/trunk/'

  depends_on 'boost-build' => :build

  def install
    cd 'tools/bcp' do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end
end
