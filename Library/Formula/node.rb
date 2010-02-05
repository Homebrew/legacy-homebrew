require 'formula'

class Node <Formula
  url 'http://s3.amazonaws.com/four.livejournal/20100203/node-v0.1.27.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 '7dffe5ee6a6f531d711235d1227b0989'

  aka 'node.js'
  
  depends_on 'gnutls' => :recommended
  
  def skip_clean? path
    # TODO: at some point someone should tweak this so it only skips clean
    # for the bits that break the build otherwise
    true
  end

  def install
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
