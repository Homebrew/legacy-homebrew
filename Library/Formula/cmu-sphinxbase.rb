require 'formula'

class CmuSphinxbase < Formula
  homepage 'http://cmusphinx.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cmusphinx/sphinxbase/0.8/sphinxbase-0.8.tar.gz'
  sha1 'c0c4d52e143d07cd593bd6bcaeb92b9a8a5a8c8e'

  depends_on 'pkg-config' => :build
  depends_on :python
  depends_on 'libsndfile' => :optional
  depends_on 'libsamplerate' => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    python.standard_caveats
  end
end
