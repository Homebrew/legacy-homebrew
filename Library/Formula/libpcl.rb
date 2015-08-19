class Libpcl < Formula
  desc "C library and API for coroutines"
  homepage "http://xmailserver.org/libpcl.html"
  url "http://xmailserver.org/pcl-1.12.tar.gz"
  sha256 "e7b30546765011575d54ae6b44f9d52f138f5809221270c815d2478273319e1a"

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
