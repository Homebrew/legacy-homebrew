require 'brewkit'

class Boost <Formula
  @homepage='http://www.boost.org'
  @url='http://kent.dl.sourceforge.net/sourceforge/boost/boost_1_39_0.tar.bz2'
  @md5='a17281fd88c48e0d866e1a12deecbcc0'

  def install
    # we specify libdir too because the script is apparently broken
    system "./bootstrap.sh --prefix='#{prefix}' --libdir='#{lib}'"
    system "./bjam --layout=system --prefix='#{prefix}' --libdir='#{lib}' install"
  end
end