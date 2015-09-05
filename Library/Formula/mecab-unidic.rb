class MecabUnidic < Formula
  desc "Morphological analyzer for MeCab"
  homepage "http://sourceforge.jp/projects/unidic/"
  url "http://sourceforge.jp/frs/redir.php?m=iij&f=%2Funidic%2F58338%2Funidic-mecab-2.1.2_src.zip"
  sha256 "6cce98269214ce7de6159f61a25ffc5b436375c098cc86d6aa98c0605cbf90d4"

  bottle do
    cellar :any
    sha256 "6c41c6ebd2ebe27af0b92beae18b1eb8abb0d0a4830b78f16b8a3feb1f42c8fe" => :yosemite
    sha256 "de02ba717c7f724d305b337ef944983d310e78fb6c58169abd1aea62f0a197e4" => :mavericks
    sha256 "9bb2a59eb6345f1a0d3da5042c0b586cad2b8227512fcb907c0c2b83bc100c29" => :mountain_lion
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-dicdir=#{lib}/mecab/dic/unidic"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
     To enable mecab-unidic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
       dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<-EOS.undent
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
