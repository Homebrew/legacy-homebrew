class Postmark < Formula
  desc "File system benchmark from NetApp"
  homepage "https://packages.debian.org/stable/utils/postmark"
  url "https://mirrors.kernel.org/debian/pool/main/p/postmark/postmark_1.51.orig.tar.gz"
  mirror "http://ftp.us.debian.org/debian/pool/main/p/postmark/postmark_1.51.orig.tar.gz"
  sha256 "7cb7c31d4e7725ce8d8e11fb7df62ed700dee4dbd5ca1e31bf3a9161fc890b41"

  bottle do
    cellar :any
    sha256 "cabe905fb4faa947b20ee8daa027101b4b827d39fa2068fe6b2cac43f24872b3" => :yosemite
    sha256 "0dec9ea7763130539dc58334f07cbad0e1e7dd157d3acb77f9a9c790b2740446" => :mavericks
    sha256 "db75ec9875810e2dded29dac2b73abc066bd1ce659928ce4489d0c8709d7e8b6" => :mountain_lion
  end

  def install
    system ENV.cc, "-o", "postmark", "postmark-#{version}.c"
    bin.install "postmark"
  end

  test do
    assert_match(/PostMark v#{version}/,
                 pipe_output("#{bin}/postmark", "run\n", 0))
  end
end
