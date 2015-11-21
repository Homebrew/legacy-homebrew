class Yamcha < Formula
  desc "NLP text chunker using Support Vector Machines"
  homepage "http://chasen.org/~taku/software/yamcha/"
  url "http://chasen.org/~taku/software/yamcha/src/yamcha-0.33.tar.gz"
  sha256 "413d4fc0a4c13895f5eb1468e15c9d2828151882f27aea4daf2399c876be27d5"

  bottle do
    sha256 "efeecbc666fd1aee3e89023d348c9dc04baace5d937ecb5a28b3097c32c30f97" => :yosemite
    sha256 "c8872d56a004ec8750d75666d6f73947ea6f7cc99819880527e5deb498b9ba06" => :mavericks
    sha1 "4f7d40d5d02e0a431486450d119e83564f795a70" => :mountain_lion
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
                   "-f", "#{libexec}/yamcha/Makefile",
                   "CORPUS=train.data", "MODEL=case_study", "train"

    %w[log model se svmdata txtmodel.gz].each do |ext|
      assert File.exist? testpath/"case_study.#{ext}"
    end
  end
end
