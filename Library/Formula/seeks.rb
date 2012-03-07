require 'formula'

class Seeks < Formula
  homepage 'http://www.seeks-project.info/site/'
  head 'git://seeks.git.sourceforge.net/gitroot/seeks/seeks', :branch => 'experimental'
  md5 ''

  depends_on 'autoconf' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libevent' => :build
  depends_on 'pcre' => :build
  depends_on 'protobuf' => :build
  depends_on 'tokyo-cabinet' => :build

  def patches
    {:p1 => "http://www.seeks-project.info/seeks/patches/osx/osx_iconv.patch"}
  end

  def install
    system "./autogen.sh"
    system "./configure", "--enable-httpserv-plugin", "--disable-opencv",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "sed -i -e 's/^#\(activated-plugin httpserv\)$/\1/' #{prefix}/etc/config"
  end
end
