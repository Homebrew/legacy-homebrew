class Postmark < Formula
  desc "File system benchmark from NetApp"
  homepage "https://packages.debian.org/sid/postmark"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/postmark/postmark_1.53.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/p/postmark/postmark_1.53.orig.tar.gz"
  sha256 "8a88fd322e1c5f0772df759de73c42aa055b1cd36cbba4ce6ee610ac5a3c47d3"

  bottle do
    cellar :any
    sha256 "cabe905fb4faa947b20ee8daa027101b4b827d39fa2068fe6b2cac43f24872b3" => :yosemite
    sha256 "0dec9ea7763130539dc58334f07cbad0e1e7dd157d3acb77f9a9c790b2740446" => :mavericks
    sha256 "db75ec9875810e2dded29dac2b73abc066bd1ce659928ce4489d0c8709d7e8b6" => :mountain_lion
  end

  def install
    system ENV.cc, "-o", "postmark", "postmark-#{version}.c"
    bin.install "postmark"
    man1.install "postmark.1"
  end

  test do
    (testpath/"config").write <<-EOS.undent
      set transactions 50
      set location #{testpath}
      run
    EOS

    output = pipe_output("#{bin}/postmark #{testpath}/config")
    assert_match /(50 per second)/, output
  end
end
