require 'formula'

class XercesC < Formula
  homepage 'http://xerces.apache.org/xerces-c/'
  url 'http://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.1.1.tar.gz'
  sha1 '177ec838c5119df57ec77eddec9a29f7e754c8b2'

  bottle do
    cellar :any
    revision 1
    sha1 "c967a33a63188465037bad103417e30ae4bcbed8" => :yosemite
    sha1 "d6312f24c9eebe9dadf87785c162c3750ec7c88d" => :mavericks
    sha1 "233d55c81c9d9f97b5f083426cc1c9dbda2bd032" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    # Remove a sample program that conflicts with libmemcached
    # on case-insensitive file systems
    (bin/"MemParse").unlink
  end
end
