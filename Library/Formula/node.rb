require 'formula'

class Node <Formula
  url 'http://s3.amazonaws.com/four.livejournal/20100120/node-v0.1.26.tar.gz'
  head 'git://github.com/ry/node.git'
  homepage 'http://nodejs.org/'
  md5 '8c65ce4bca6789d838401c29b41bcb58'

  aka 'node.js'

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
