class JoshuaV < Formula
  desc "Joshua is an open-source statistical machine translation decoder."
  homepage "http://joshua-decoder.org/"
  url "http://cs.jhu.edu/~post/files/joshua-v6.0.4.tgz"
  sha256 "0e3b08c80303106599aa404bbba5c801cc5542779bef828d35ff80288190c273"
  head "https://github.com/joshua-decoder/joshua.git"

  option "with-language-packs", "Build with all available community language packs (es-->en and ar-->en)"
  option "with-es-en-phrase-pack", "Build with Spanish–English phrase-based model [1.9 GB]."
  option "with-ar-en-phrase-pack", "Build with Arabic–English phrase-based model [2.4 GB]."

  depends_on "ant" => :build
  depends_on "boost" => :build
  depends_on "md5sha1sum" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  resource "es-en-phrase-pack" do
    url "http://cs.jhu.edu/~post/language-packs/language-pack-es-en-phrase-2015-03-06.tgz"
    sha256 "213e05bbdcfbfa05b31e263c31f10a0315695fee26c2f37b0a78fb918bad9b5d"
  end

  resource "ar-en-phrase-pack" do
    url "http://cs.jhu.edu/~post/language-packs/language-pack-ar-en-phrase-2015-03-18.tgz"
    sha256 "2b6665b58b11e4c25d48191d3d5b62b7c591851a9767b14f9ccebf1951fddf90"
  end

  resource "indian-parallel-corpora" do
    url "https://github.com/joshua-decoder/indian-parallel-corpora/archive/1.0.tar.gz"
    sha256 "b6472648d9c13d72682554fd2434e2dc124433b6f6d9f39c16859759f30720c6"
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
    prefix.install Dir["*"]
  end

  test do
    resource("indian-parallel-corpora").stage { share.install "indian-parallel-corpora-1.0", share/"corpora" }
    ln "-s joshua-decoder-indian-parallel-corpora-* input"
    system "$JOSHUA/bin/pipeline.pl --source bn --target en \
    --no-prepare --aligner berkeley \
    --type hiero \
    --corpus input/bn-en/tok/training.bn-en \
    --tune input/bn-en/tok/dev.bn-en \
    --test input/bn-en/tok/devtest.bn-en"
  end
end
