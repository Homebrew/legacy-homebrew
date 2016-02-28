class Joshua < Formula
  desc "Statistical machine translation decoder."
  homepage "http://joshua-decoder.org/"
  url "https://cs.jhu.edu/~post/files/joshua-6.0.5.tgz"
  sha256 "972116a74468389e89da018dd985f1ed1005b92401907881a14bdcc1be8bd98a"
  head "https://github.com/joshua-decoder/joshua.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c373b6ed390b6fdc1f9fca0feb59306539aba04cb95d8f4a72af6215d7bc0969" => :el_capitan
    sha256 "2e3c7ba471fbd45fa321e2e17f12debe6f3256dfc1e546fe654e4b4942d43f50" => :yosemite
    sha256 "577237cd1bd6b58e274a78d7dd262440a980319111b9d516f74086aad36b78b5" => :mavericks
  end

  option "with-es-en-phrase-pack", "Build with Spanish–English phrase-based model [1.9 GB]."
  option "with-ar-en-phrase-pack", "Build with Arabic–English phrase-based model [2.4 GB]."

  depends_on :java
  depends_on "ant" => :build
  depends_on "boost" => :build
  depends_on "md5sha1sum" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  resource "es-en-phrase-pack" do
    url "https://cs.jhu.edu/~post/language-packs/language-pack-es-en-phrase-2015-03-06.tgz"
    sha256 "213e05bbdcfbfa05b31e263c31f10a0315695fee26c2f37b0a78fb918bad9b5d"
  end

  resource "ar-en-phrase-pack" do
    url "https://cs.jhu.edu/~post/language-packs/language-pack-ar-en-phrase-2015-03-18.tgz"
    sha256 "2b6665b58b11e4c25d48191d3d5b62b7c591851a9767b14f9ccebf1951fddf90"
  end

  def install
    rm Dir["lib/*.{gr,tar.gz}"]
    rm_rf "lib/README"
    rm_rf "bin/.gitignore"
    head do
      system "ant"
    end
    if build.with? "es-en-phrase-pack"
      resource("es-en-phrase-pack").stage { share.install "language-pack-es-en-phrase-2015-03-06", share/"joshualanguagepacks" }
    end
    if build.with? "ar-en-phrase-pack"
      resource("ar-en-phrase-pack").stage { share.install "language-pack-ar-en-phrase-2015-03-18", share/"joshualanguagepacks" }
    end
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    inreplace "#{bin}/joshua-decoder", "JOSHUA\=$(dirname $0)/..", "#JOSHUA\=$(dirname $0)/.."
    inreplace "#{bin}/decoder", "JOSHUA\=$(dirname $0)/..", "#JOSHUA\=$(dirname $0)/.."
  end

  test do
    assert_equal "test_OOV\n", pipe_output("#{libexec}/bin/joshua-decoder -v 0 -output-format %s -mark-oovs", "test")
  end
end
