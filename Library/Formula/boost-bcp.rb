require 'formula'

class BoostBcp < Formula
  homepage 'http://www.boost.org/doc/tools/bcp/'
  url 'http://downloads.sourceforge.net/project/boost/boost/1.54.0/boost_1_54_0.tar.bz2'
  sha1 '230782c7219882d0fab5f1effbe86edb85238bf4'

  head 'http://svn.boost.org/svn/boost/trunk/'

  depends_on 'boost-build' => :build

  def install
    cd 'tools/bcp' do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end
end
