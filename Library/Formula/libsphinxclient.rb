require 'formula'

class Libsphinxclient < Formula
  url 'http://sphinxsearch.com/downloads/sphinx-0.9.9.tar.gz'
  homepage 'http://www.sphinxsearch.com'
  md5 '7b9b618cb9b378f949bb1b91ddcc4f54'
  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  def install
    Dir.chdir "sphinx-#{version}/api/libsphinxclient" do
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make install"
    end
  end
end