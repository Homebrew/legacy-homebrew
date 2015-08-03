class MecabUnidic < Formula
  desc "Morphological analyzer for MeCab"
  homepage "http://sourceforge.jp/projects/unidic/"
  url "http://sourceforge.jp/frs/redir.php?m=iij&f=%2Funidic%2F58338%2Funidic-mecab-2.1.2_src.zip"
  sha256 "6cce98269214ce7de6159f61a25ffc5b436375c098cc86d6aa98c0605cbf90d4"

  depends_on "mecab"

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
