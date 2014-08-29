require 'formula'

class Giflib < Formula
  homepage 'http://giflib.sourceforge.net/'
  # 4.2.0 has breaking API changes; don't update until
  # things in $(brew uses giflib) are compatible
  url 'https://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.1.6/giflib-4.1.6.tar.bz2'
  sha1 '22680f604ec92065f04caf00b1c180ba74fb8562'

  bottle do
    cellar :any
    revision 1
    sha1 "e99b2399840944556718eed7cb2d1cd6157c180c" => :mavericks
    sha1 "d0fcd488bf297fa37308a871e4429461d9883a77" => :mountain_lion
    sha1 "444a87614d92ffa84e0a033dd7275ff2b7c3ab50" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
