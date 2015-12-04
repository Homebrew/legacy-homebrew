class MecabUnidic < Formula
  desc "Morphological analyzer for MeCab"
  homepage "https://osdn.jp/projects/unidic/"
  url "http://dl.osdn.jp/unidic/58338/unidic-mecab-2.1.2_src.zip"
  sha256 "6cce98269214ce7de6159f61a25ffc5b436375c098cc86d6aa98c0605cbf90d4"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "9ece990d89f8949c82003296bd256ebafddaf5d9caf03a63ea692f2009d52783" => :el_capitan
    sha256 "f81fd4ff64eb6b7731fd4b818b17398b1eaea3d12d533a7340b9b12aa2331c0d" => :yosemite
    sha256 "0f5b5d2d705004d502da930f1b8671a5ac34ad8d35ba7547846fa16577b43c87" => :mavericks
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
