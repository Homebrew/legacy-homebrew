require 'brewkit'

class Node <Formula
  url 'http://s3.amazonaws.com/four.livejournal/20091009/node-v0.1.14.tar.gz'
  homepage 'http://nodejs.org/'
  md5 '7f73e4ca88ded4a9b102fdd4f6d18adf'

  def install
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
