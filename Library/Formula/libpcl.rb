require 'formula'

class Libpcl < Formula
  desc "C library and API for coroutines"
  homepage 'http://xmailserver.org/libpcl.html'
  url 'http://xmailserver.org/pcl-1.12.tar.gz'
  sha1 'a206c8fb5a96e65005f414ac46aeccd4b3603c8d'

  bottle do
    cellar :any
    revision 1
    sha1 "f765f414f926e08424a150ef9d6ed0c781c747a5" => :yosemite
    sha1 "659570156b38f819a880f0cb4e8650129b4c6d29" => :mavericks
    sha1 "144245dc5c42c66e42144a7ccfa648fc96550752" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
