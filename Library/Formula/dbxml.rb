require 'formula'

class Dbxml < Formula
  url 'http://download-east.oracle.com/berkeley-db/dbxml-2.5.16.tar.gz'
  homepage 'http://www.oracle.com/us/products/database/berkeley-db/index-066571.html'
  md5 '2732618d5c4f642fba3d2a564a025986'

  depends_on 'xerces-c'
  depends_on 'xqilla'
  depends_on 'berkeley-db'

  def patches
    # Make DBXML 2.5.16 compile against Berkeley DB 5.1
    "https://raw.github.com/gist/1280960/6516bfbfdd6fcc04c6f131b8e73888a2e846d40d/gistfile1.diff"
  end

  def install
    Dir.chdir "dbxml" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-berkeleydb=#{HOMEBREW_PREFIX}",
                            "--with-xqilla=#{HOMEBREW_PREFIX}",
                            "--with-xerces=#{HOMEBREW_PREFIX}"
      system "make install"
    end
  end
end
