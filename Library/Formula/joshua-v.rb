class JoshuaV < Formula
  desc "Joshua is an open-source statistical machine translation decoder."
  homepage "http://joshua-decoder.org/"
  url "http://cs.jhu.edu/~post/files/joshua-v6.0.4.tgz"
  sha256 "0cf6674dc73f30e49a22179e90182492f8e8eea46710b505edb9acfb4d953d9a" 
  head "https://github.com/joshua-decoder/joshua.git"

  option "with-language-packs", "Build with all available community language packs (es-->en and ar-->en)"
  option "with-es-en-phrase-pack", "Build with Spanish–English phrase-based model [1.9 GB]."
  option "with-ar-en-phrase-pack", "Build with Arabic–English phrase-based model [2.4 GB]." 

  depends_on "ant" => :build
  depends_on "boost" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  resource "es-en-phrase-pack" do
    url "http://cs.jhu.edu/~post/language-packs/language-pack-es-en-phrase-2015-03-06.tgz"
    sha256 "213E05BBDCFBFA05B31E263C31F10A0315695FEE26C2F37B0A78FB918BAD9B5D"
  end

  resource "ar-en-phrase-pack" do
    url "http://cs.jhu.edu/~post/language-packs/language-pack-ar-en-phrase-2015-03-18.tgz"
    sha256 "2B6665B58B11E4C25D48191D3D5B62B7C591851A9767B14F9CCEBF1951FDDF90"
  end

  def install
    system "ant"   
    if build.with? "language-packs"
      resource("es-en-phrase-pack").stage { share.install "language-pack-es-en-phrase-2015-03-06", share/"joshualanguagepacks" }
      resource("ar-en-phrase-pack").stage { share.install "language-pack-ar-en-phrase-2015-03-18", share/"joshualanguagepacks" }
    elsif build.with? "es-en-phrase-pack"
      resource("es-en-phrase-pack").stage { share.install "language-pack-es-en-phrase-2015-03-06", share/"joshualanguagepacks" }
    elsif build.with? "ar-en-phrase-pack"
      resource("ar-en-phrase-pack").stage { share.install "language-pack-ar-en-phrase-2015-03-18", share/"joshualanguagepacks" }
    end
  end

  test do    
    system "mkdir -p ~/models/bn-en"
    system "cd ~/models/bn-en"
    system "curl -L https://github.com/joshua-decoder/indian-parallel-corpora/tarball/master > indian-languages.tgz"
    system "tar xf indian-languages.tgz"
    system "ln -s joshua-decoder-indian-parallel-corpora-* input"
    system "$JOSHUA/bin/pipeline.pl --source bn --target en \
    --no-prepare --aligner berkeley \
    --type hiero \
    --corpus input/bn-en/tok/training.bn-en \
    --tune input/bn-en/tok/dev.bn-en \
    --test input/bn-en/tok/devtest.bn-en"
  end
end