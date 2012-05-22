require 'formula'

class Nzbget < Formula
  homepage 'http://sourceforge.net/projects/nzbget/'
  url 'http://downloads.sourceforge.net/project/nzbget/nzbget-stable/0.8.0/nzbget-0.8.0.tar.gz'
  md5 'c47f464fe988deeb4fc5381506c1fbe3'
  head 'https://nzbget.svn.sourceforge.net/svnroot/nzbget/trunk', :using => :svn

  # Also depends on libxml2 but the one in OS X is fine
  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  depends_on 'libpar2'
  depends_on 'gnutls'

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      Configure errors out when testing the libpar2 headers because
      Clang does not support flexible arrays of non-POD types.
      EOS
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    prefix.install 'nzbget.conf.example', 'postprocess-example.conf'
  end
end
