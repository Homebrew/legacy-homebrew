require 'formula'

class XercesC < Formula
  homepage 'http://xerces.apache.org/xerces-c/'
  url 'http://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.1.1.tar.gz'
  sha1 '177ec838c5119df57ec77eddec9a29f7e754c8b2'

  bottle do
    cellar :any
    sha1 "36fa7257f3e638345b55c45acd28e193ccc354c7" => :mavericks
    sha1 "d84abb14f4b4de510a625903397f9563bff844fc" => :mountain_lion
    sha1 "b797ccd92031ab42c6fecbd2ec08678c720d1c3f" => :lion
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
