require 'brewkit'

class Boost <Formula
  @homepage='http://www.boost.org'
  @url='http://downloads.sourceforge.net/project/boost/boost/1.40.0/boost_1_40_0.tar.bz2'
  @md5='ec3875caeac8c52c7c129802a8483bd7'

  def install
    # we specify libdir too because the script is apparently broken
    system "./bootstrap.sh --prefix='#{prefix}' --libdir='#{lib}'"
    system "./bjam --layout=tagged --prefix='#{prefix}' --libdir='#{lib}' threading=multi install"
  end
end