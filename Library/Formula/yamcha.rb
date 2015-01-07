class Yamcha < Formula
  homepage "http://chasen.org/~taku/software/yamcha/"
  url "http://chasen.org/~taku/software/yamcha/src/yamcha-0.33.tar.gz"
  sha1 "4ee6d8150557761f86fcb8af118636b7c23920c0"

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
