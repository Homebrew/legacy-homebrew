require 'formula'

class MecabIpadic < Formula
  url 'http://downloads.sourceforge.net/project/mecab/mecab-ipadic/2.7.0-20070801/mecab-ipadic-2.7.0-20070801.tar.gz'
  homepage 'http://mecab.sourceforge.net/'
  md5 'e09556657cc70e45564c6514a6b08495'

  depends_on "mecab"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << ARGV.find(Proc.new {"--with-charset=utf8"}) { |arg| /^--with-charset/.match(arg) }

    system "./configure", *args
    system "make install"
  end
end
