class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "http://www.spinnaker.de/lbdb/"
  url "http://www.spinnaker.de/debian/lbdb_0.41.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/lbdb/lbdb_0.41.tar.xz"
  sha256 "fc9261cdc361d95e33da08762cafe57f8b73ab2598f9073986f0f9e8ad64a813"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ce4fe2c478ff098f15498a6e3bb68045d17695234f7d8bb5a10292c7d279778" => :el_capitan
    sha256 "2b0d428903f819fa92fb66ac2ffc255366371ee9aed7ee2d4a3c21ce0c9d5f1c" => :yosemite
    sha256 "103383cc3856d211c8773cdcf88f202f421f74a7294df24c356dbc5a2e52add6" => :mavericks
  end

  depends_on :gpg => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --libdir=#{libexec}
    ]
    args << "--with-gpg" if build.with? "gpg"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
