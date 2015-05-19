class Cmatrix < Formula
  desc "Console Matrix"
  homepage "http://www.asty.org/cmatrix/"
  url "http://www.asty.org/cmatrix/dist/cmatrix-1.2a.tar.gz"
  sha1 "ca078c10322a47e327f07a44c9a42b52eab5ad93"

  bottle do
    cellar :any
    sha1 "5716eb3e6438f79fde10d103cc51d44621be0851" => :yosemite
    sha1 "470186c129b19721b3504e88ecb66ae756722251" => :mavericks
    sha1 "f57962ae1d59e81ceffa6534a43c849a993b6f38" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/cmatrix", "-V"
  end
end
