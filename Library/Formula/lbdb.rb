class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "http://www.spinnaker.de/lbdb/"
  url "http://www.spinnaker.de/debian/lbdb_0.41.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/lbdb/lbdb_0.41.tar.xz"
  sha256 "fc9261cdc361d95e33da08762cafe57f8b73ab2598f9073986f0f9e8ad64a813"

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
