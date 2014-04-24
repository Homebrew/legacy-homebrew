require 'formula'

class Cabocha < Formula
  homepage 'http://code.google.com/p/cabocha/'
  url 'https://cabocha.googlecode.com/files/cabocha-0.68.tar.bz2'
  sha1 '5e22a71eb86d778fdeb1b725c0b27f1fb4af7f4b'

  depends_on 'crf++'
  depends_on 'mecab'

  # To see which dictionaries are available, run:
  #     ls `mecab-config --libs-only-L`/mecab/dic/
  depends_on 'mecab-ipadic' => :recommended
  depends_on 'mecab-jumandic' => :optional
  depends_on 'mecab-unidic' => :optional

  option 'charset=', 'choose default charset: EUC-JP, CP932, UTF8'
  option 'posset=', 'choose default posset: IPA, JUMAN, UNIDIC'

  def install
    ENV["LIBS"] = '-liconv'

    inreplace 'Makefile.in' do |s|
      s.change_make_var! 'CFLAGS', ENV.cflags
      s.change_make_var! 'CXXFLAGS', ENV.cflags
    end

    charset = ARGV.value('charset') || 'UTF8'
    posset = ARGV.value('posset') || "IPA"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=#{charset}
      --with-posset=#{posset}
    ]

    system "./configure", *args
    system "make install"
  end
end
