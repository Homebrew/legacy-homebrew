require 'formula'

class Ragel < Formula
  homepage 'http://www.complang.org/ragel/'
  url 'http://www.complang.org/ragel/ragel-6.8.tar.gz'
  sha1 '95cabbcd52bd25d76c588ddf11e1fd242d7cbcc7'

  resource 'pdf' do
    url 'http://www.complang.org/ragel/ragel-guide-6.8.pdf'
    sha1 'e57ee7f740dd395d4d5330949594a02c91ad0308'
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
    doc.install resource('pdf')
  end
end
