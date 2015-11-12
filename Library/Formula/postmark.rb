class Postmark < Formula
  desc "File system benchmark from NetApp"
  homepage "https://packages.debian.org/sid/postmark"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/postmark/postmark_1.53.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/p/postmark/postmark_1.53.orig.tar.gz"
  sha256 "8a88fd322e1c5f0772df759de73c42aa055b1cd36cbba4ce6ee610ac5a3c47d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "784b46fe9883d27d347a44da73413ccf5c589088c0b57da577ebc1c79e64e1e6" => :el_capitan
    sha256 "7fb38c3960e124a836cdc48650fd5f4d1fc446897b590e0dd6b6b6b5cbdec522" => :yosemite
    sha256 "2ccb3812b371bc02e66d84ff853cb9684f8941485af3287424b4c183205bc649" => :mavericks
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
