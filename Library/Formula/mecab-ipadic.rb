require 'formula'

class MecabIpadic < Formula
  url 'http://downloads.sourceforge.net/project/mecab/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz'
  homepage 'http://mecab.sourceforge.net/'
  sha1 '0d9d021853ba4bb4adfa782ea450e55bfe1a229b'

  depends_on "mecab"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << ARGV.find(Proc.new {"--with-charset=utf8"}) { |arg| /^--with-charset/.match(arg) }

    system "./configure", *args
    system "make install"
  end
end
