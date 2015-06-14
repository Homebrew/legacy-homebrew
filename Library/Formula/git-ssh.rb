class GitSsh < Formula
  desc "Proxy for serving git repositories over SSH"
  homepage "https://github.com/lemarsu/git-ssh"
  url "https://github.com/lemarsu/git-ssh/archive/v0.2.0.tar.gz"
  sha256 "f7cf45f71e1f3aa23ef47cbbc411855f60d15ee69992c9f57843024e241a842f"

  head "https://github.com/lemarsu/git-ssh.git"

  bottle do
    cellar :any
    sha256 "24e1f6a4d2dfe83141cd869cf75a512e98079a48267afce34032babd64a9fac5" => :yosemite
    sha256 "7521baa200f0917ae75167e2f16fbaf41990dc0a13031f9aa2d94a68fcff8140" => :mavericks
    sha256 "5edbeb19d4c76a82ec29e62e2cbe3a0860b62697f70b96bcc0e472dc8c065a6a" => :mountain_lion
  end

  def install
    # Change loading of required code from libexec location (Cellar only)
    inreplace "bin/git-ssh" do |s|
      s.sub!(/path = .*$/, "path = '#{libexec}'")
    end
    bin.install "bin/git-ssh"
    libexec.install Dir["lib/*"]
  end

  test do
    assert_equal "#{bin}/git-ssh v0.2.0",
      shell_output("#{bin}/git-ssh -V").chomp
  end
end
