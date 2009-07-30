require 'brewkit'

class Python <Formula
  @url='http://www.python.org/ftp/python/2.6.2/Python-2.6.2.tar.bz2'
  @homepage='http://www.python.org/'
  @md5='245db9f1e0f09ab7e0faaa0cf7301011'

  def install
    # TODO:
    #   Bring virtualenv along for the ride.
    #   Rename the formula to python26?
    #      -- one feature I plan for homebrew is one can do, eg.
    #            brew install -v2.6
    #         and also, versioning packages in the name sucks :) --mxcl
    
    system "./configure --prefix='#{prefix}'"
    system "make"
    system "make install"
  end
end
