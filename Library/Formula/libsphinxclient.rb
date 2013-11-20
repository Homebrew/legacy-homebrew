require 'formula'

class Libsphinxclient < Formula
  homepage 'http://www.sphinxsearch.com'
  url 'http://sphinxsearch.com/files/sphinx-2.1.3-release.tar.gz'
  sha1 'f558dd2b96dabf26f533f5982bf1784582bf6f32'

  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  devel do
    url 'http://sphinxsearch.com/files/sphinx-2.2.1-beta.tar.gz'
    sha1 'dccaa7d14f71cec8fe6dfdb059315856c0712885'
  end

  def install
    Dir.chdir "api/libsphinxclient"

    # libsphinxclient doesn't seem to support concurrent jobs:
    #  https://bbs.archlinux.org/viewtopic.php?id=77214
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
