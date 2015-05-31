# encoding: UTF-8
class Mecab < Formula
  desc "Yet Another Part-of-Speech and Morphological Analyzer"
  homepage "https://taku910.github.io/mecab/"
  url "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE"
  version "0.996"
  sha256 "e073325783135b72e666145c781bb48fada583d5224fb2490fb6c1403ba69c59"

  bottle do
    revision 1
    sha1 "73f5e7206a4482f7ab714b0690ad3eeac7f0c9e0" => :yosemite
    sha1 "530ee77a2f13cce3225abd0cd9401858219959d9" => :mavericks
    sha1 "9747369cd4c0aa246e6a973c4f2e5652e174bae8" => :mountain_lion
  end

  option "with-unidic", "UniDic"

  resource "unidic" do
    # https://osdn.jp/projects/unidic/
    url "http://dl.osdn.jp/unidic/58338/unidic-mecab-2.1.2_src.zip"
    sha256 "6cce98269214ce7de6159f61a25ffc5b436375c098cc86d6aa98c0605cbf90d4"
  end

  def install
    if build.include? "unidic"
      resource("unidic").stage do
        cd ("unidic") do
          system "./configure", "--disable-debug", "--disable-dependency-tracking",
                                "--prefix=#{prefix}"
          system "make", "install"
        end
      end
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    def caveats; <<-EOS.undent
      If you want to use an alternate dictionary, please rewrite "dicdir".
         #{opt_prefix}/etc/mecabrc
      EOS
    end
  end

  test do
    result = `echo "mecabのテストです。" | mecab |md5`.chomp
    assert_equal "3518edb94fe7fbd3784474f2ddc02905", result
  end
end
