class Yamcha < Formula
  desc "NLP text chunker using Support Vector Machines"
  homepage "http://chasen.org/~taku/software/yamcha/"
  url "http://chasen.org/~taku/software/yamcha/src/yamcha-0.33.tar.gz"
  sha256 "413d4fc0a4c13895f5eb1468e15c9d2828151882f27aea4daf2399c876be27d5"

  bottle do
    cellar :any
    revision 1
    sha256 "b65fade9c6ddcced1d3c3fc6700f18ed2ddd16b62437fc71f9a85a3568851520" => :el_capitan
    sha256 "b038ddce247b7f56041c4325fd01c0ab0b32399d1ca602df37b65739a09b74e0" => :yosemite
    sha256 "6b43b01d7d2385706e3259a49e8944368edef3a20755ea4093f4e3ebbf56eb27" => :mavericks
  end

  depends_on "tinysvm"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    libexecdir = shell_output("#{bin}/yamcha-config --libexecdir").chomp
    assert_equal libexecdir, "#{libexec}/yamcha"

    (testpath/"train.data").write <<-EOS.undent
    He        PRP  B-NP
    reckons   VBZ  B-VP
    the       DT   B-NP
    current   JJ   I-NP
    account   NN   I-NP
    deficit   NN   I-NP
    will      MD   B-VP
    narrow    VB   I-VP
    to        TO   B-PP
    only      RB   B-NP
    #         #    I-NP
    1.8       CD   I-NP
    billion   CD   I-NP
    in        IN   B-PP
    September NNP  B-NP
    .         .    O

    He        PRP  B-NP
    reckons   VBZ  B-VP
    ..
    EOS

    system "make", "-j", "1",
                   "-f", "#{libexecdir}/Makefile",
                   "CORPUS=train.data", "MODEL=case_study", "train"

    %w[log model se svmdata txtmodel.gz].each do |ext|
      assert File.exist? testpath/"case_study.#{ext}"
    end
  end
end
