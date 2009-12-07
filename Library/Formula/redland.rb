require 'formula'

class Redland <Formula
  @url='http://download.librdf.org/source/redland-1.0.9.tar.gz'
  @homepage='http://librdf.org/'
  @md5='e5ef0c29c55b4f0f5aeed7955b4d383b'

  depends_on 'raptor'
  depends_on 'rasqal'
  depends_on 'pkg-config'
  depends_on 'berkeley-db' => :optional

  def install
    ENV.gcc_4_2

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-sqlite=yes",
                          "--with-bdb=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
