class Ssss < Formula
  desc "Shamir's secret sharing scheme implementation"
  homepage "http://point-at-infinity.org/ssss/"
  url "http://point-at-infinity.org/ssss/ssss-0.5.tar.gz"
  sha256 "5d165555105606b8b08383e697fc48cf849f51d775f1d9a74817f5709db0f995"

  depends_on "gmp"
  depends_on "xmltoman"

  def install
    inreplace "Makefile" do |s|
      # Compile with -DNOMLOCK to avoid warning on every run on OS X.
      s.gsub! /\-W /, "-W -DNOMLOCK $(CFLAGS) $(LDFLAGS)"
    end

    system "make"
    man1.install "ssss.1"
    bin.install %w[ssss-combine ssss-split]
  end
end
