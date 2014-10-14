require 'formula'

class Libfishsound < Formula
  homepage 'http://xiph.org/fishsound/'
  url 'http://downloads.xiph.org/releases/libfishsound/libfishsound-1.0.0.tar.gz'
  sha1 '5263dfaa12dce71e30c5d80f871d92869c6b5ce2'

  bottle do
    cellar :any
    sha1 "ef415e726cd7f54f1ac7c0a277ef2535ef8be867" => :mavericks
    sha1 "663fc1ea81771c2e517514670ca8c7bfcb0af184" => :mountain_lion
    sha1 "86915dd39751989c022a71ea81b6bbc6f7539b53" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libvorbis'
  depends_on 'speex' => :optional
  depends_on 'flac' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
