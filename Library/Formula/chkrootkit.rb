class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/chkrootkit/chkrootkit_0.50.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/chkrootkit/chkrootkit_0.50.orig.tar.gz"
  sha256 "9548fc922b0cb8ddf055faff4a4887f140a31c45f2f5e3aa64aad91ecfa56cc7"

  bottle do
    cellar :any_skip_relocation
    sha256 "d631f10284719bd507c6e08bfadc68507adda611d1488dfe6f59f2cdf3b7d1e9" => :el_capitan
    sha256 "e55c78bfac4b081cef6b51e46cf3ff7fed13b4150f8772535fa401e83bcfe213" => :yosemite
    sha256 "db4476a3cfc7d10f9991628c95068784c702662bc0be79b124fd775c56c65ecf" => :mavericks
    sha256 "8aa44d8d76a8d6ddbc27adac04e64e3120c4599b2d617ff0fa82d15f8229957b" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
