require 'brewkit'

class Wrangler <Formula
  @url='http://www.cs.kent.ac.uk/projects/forse/wrangler/wrangler-0.8/wrangler-0.8.1.tar.gz'
  @homepage='http://www.cs.kent.ac.uk/projects/forse/'
  @md5='0ddc9308eb82382d11d0a6df486050b5'

  def deps
    BinaryDep.new 'erlang'
  end
  
  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
