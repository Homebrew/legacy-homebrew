require 'formula'

class Nzbget < Formula
  url 'http://downloads.sourceforge.net/project/nzbget/nzbget-stable/0.8.0/nzbget-0.8.0.tar.gz'
  homepage 'http://sourceforge.net/projects/nzbget/'
  md5 'c47f464fe988deeb4fc5381506c1fbe3'
  head 'https://nzbget.svn.sourceforge.net/svnroot/nzbget/trunk', :using => :svn

  # Also depends on libxml2 but the one in OS X is fine
  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  depends_on 'libpar2'
  depends_on 'gnutls'

  fails_with :clang do
    build 318
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
	prefix.install "nzbget.conf.example"
	prefix.install "postprocess-example.conf"
  end
end
