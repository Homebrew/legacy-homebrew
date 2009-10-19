require 'formula'

class Node <Formula
  url 'http://s3.amazonaws.com/four.livejournal/20091107/node-v0.1.17.tar.gz'
  homepage 'http://nodejs.org/'
  md5 '4e6c0427da7ff67cd475f28affb859e4'

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
