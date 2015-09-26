class JoshuaV < Formula
  desc "Joshua is an open-source statistical machine translation decoder for phrase-based, hierarchical, and syntax-based machine translation, written in Java."
  homepage "http://joshua-decoder.org/"
  url "http://cs.jhu.edu/~post/files/joshua-v6.0.4.tgz"
  version "6.0.4"
  sha256 "0cf6674dc73f30e49a22179e90182492f8e8eea46710b505edb9acfb4d953d9a"
  head "https://github.com/joshua-decoder/joshua.git"

  option "with-language-packs", "Build with all available community language packs (es-->en and ar-->en)"

  option "with-es-en-phrase-pack", "Build with Spanish–English phrase-based model [1.9 GB], built on Europarl and the Fisher and CALLHOME parallel dataset."

  option "with-ar-en-phrase-pack", "Build with Arabic–English phrase-based model [2.4 GB], built from the LDC Arabic-Dialect/English parallel text, the ISI Arabic–English automatically extracted parallel text, and translations of the Arabic CALLHOME transcripts, and with an English Gigaword language model."

  depends_on "ant" => :build

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
    
    system "ant javadoc"
    
    if build.with? "language-packs"
      resource("es-en-phrase-pack").stage { mv "language-pack-es-en-phrase-2015-03-06", share/"joshualanguagepacks" }
      resource("ar-en-phrase-pack").stage { mv "language-pack-ar-en-phrase-2015-03-18", share/"joshualanguagepacks" }
    elsif build.with? "es-en-phrase-pack"
      resource("es-en-phrase-pack").stage { mv "language-pack-es-en-phrase-2015-03-06", share/"joshualanguagepacks" }
    elsif build.with? "ar-en-phrase-pack"
      resource("ar-en-phrase-pack").stage { mv "language-pack-ar-en-phrase-2015-03-18", share/"joshualanguagepacks" }
    end
  end

  test do    
    system "ant test"
  end
end
