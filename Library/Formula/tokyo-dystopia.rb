class TokyoDystopia < Formula
  homepage "http://fallabs.com/tokyodystopia/"
  url "http://fallabs.com/tokyodystopia/tokyodystopia-0.9.15.tar.gz"
  sha256 "28b43c592a127d1c9168eac98f680aa49d1137b4c14b8d078389bbad1a81830a"

  depends_on "tokyo-cabinet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.tsv").write <<-EOS.undent
      1\tUnited States
      55\tBrazil
      81\tJapan
    EOS

    system "#{bin}/dystmgr", "importtsv", "casket", "test.tsv"
    system "#{bin}/dystmgr", "put", "casket", "83", "China"
    system "#{bin}/dystmgr", "list", "-pv", "casket"
  end
end
