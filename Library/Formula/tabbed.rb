require 'formula'

class Tabbed < Formula
  homepage 'http://tools.suckless.org/tabbed'
  url 'http://dl.suckless.org/tools/tabbed-0.6.tar.gz'
  sha1 '3c64d79817337f86f0cdd60b5b79af7e77d4a5f9'

  bottle do
    cellar :any
    sha1 "dfd3264ddf73626663508e058a3ff417cacc9ddf" => :mavericks
    sha1 "d6a1e8f8e4e719b89956a5ae4ebea916f7d81fed" => :mountain_lion
    sha1 "823a4e327e626120283262116f15ee47cd0a3f6a" => :lion
  end

  head 'http://git.suckless.org/tabbed', :using => :git

  depends_on :x11

  def install
    inreplace 'config.mk', "LIBS = -L/usr/lib -lc -lX11", "LIBS = -L#{MacOS::X11.lib} -lc -lX11"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
