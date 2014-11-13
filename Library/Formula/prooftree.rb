require 'formula'

class Prooftree < Formula
  homepage 'http://askra.de/software/prooftree'
  url 'http://askra.de/software/prooftree/releases/prooftree-0.10.tar.gz'
  sha1 'ac9ba265062382109673320635d822f92e6a126c'

  bottle do
    cellar :any
    sha1 "686cb57124632efd5dcc72b9b3821c64c105ffd4" => :mavericks
    sha1 "c4707a4ddd9da81e2527ba693de96f47340e1307" => :mountain_lion
    sha1 "ebabfe1c7299976f037adfae5d2b90fb4878b186" => :lion
  end

  depends_on :x11
  depends_on 'lablgtk'

  def install
    system "./configure", "--prefix", prefix
    system "make"
    system "make install"
  end
end
