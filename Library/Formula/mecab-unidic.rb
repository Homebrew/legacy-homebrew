require 'formula'

class MecabUnidic < Formula
  homepage 'http://sourceforge.jp/projects/unidic/'
  url 'http://sourceforge.jp/frs/redir.php?m=iij&f=%2Funidic%2F58338%2Funidic-mecab-2.1.2_src.zip'
  sha1 'c501246539e4e2bd5b04c731fcb04985cccf8bcf'

  depends_on 'mecab'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    If you want to use UniDic, please rewrite "dicdir".
       #{Formula["mecab"].opt_prefix}/etc/mecabrc
    EOS
  end
end
