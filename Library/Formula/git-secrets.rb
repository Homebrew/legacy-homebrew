class GitSecrets < Formula
  desc "Prevents you from committing sensitive information to a git repo"
  homepage "https://github.com/awslabs/git-secrets"
  url "https://github.com/awslabs/git-secrets/archive/1.0.0.tar.gz"
  sha256 "3fac12be9e1cd0f67daf801db17ebd9b1b302c2cc22e3b9c52aca7e55fdcd84f"

  head "https://github.com/awslabs/git-secrets.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "secrets", "--install"
  end
end
