class GitSsh < Formula
  desc "Proxy for serving git repositories over SSH"
  homepage "https://github.com/lemarsu/git-ssh"
  url "https://github.com/lemarsu/git-ssh/archive/v0.2.0.tar.gz"
  sha256 "f7cf45f71e1f3aa23ef47cbbc411855f60d15ee69992c9f57843024e241a842f"
  head "https://github.com/lemarsu/git-ssh.git"

  bottle :unneeded

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
