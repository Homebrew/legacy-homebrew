class Postmark < Formula
  homepage "https://packages.debian.org/stable/utils/postmark"
  url "https://mirrors.kernel.org/debian/pool/main/p/postmark/postmark_1.51.orig.tar.gz"
  mirror "http://ftp.us.debian.org/debian/pool/main/p/postmark/postmark_1.51.orig.tar.gz"
  sha256 "7cb7c31d4e7725ce8d8e11fb7df62ed700dee4dbd5ca1e31bf3a9161fc890b41"

  def install
    system ENV.cc, "-o", "postmark", "postmark-#{version}.c"
    bin.install "postmark"
  end

  test do
    assert_match(/PostMark v#{version}/,
                 pipe_output("#{bin}/postmark", "run\n", 0))
  end
end
