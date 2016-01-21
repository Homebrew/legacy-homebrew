class GitSecrets < Formula
  desc "Prevents you from committing sensitive information to a git repo"
  homepage "https://github.com/awslabs/git-secrets"
  url "https://github.com/awslabs/git-secrets/archive/1.0.1.tar.gz"
  sha256 "887cf60afb886a969af87ef807a32eca56c84869a002ef617efd7961af3b8f77"

  head "https://github.com/awslabs/git-secrets.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "167a9368281483ab3b12ef357b8ce902c1504dceba3244856ea0c3f436b89b58" => :el_capitan
    sha256 "d3bc63056ae93f0faf6c1ae162325479b87d1bd5be3fe0495f1ae38ae7c9cc87" => :yosemite
    sha256 "ed704030babb07a359d332811f9f97b98b48b1bd9e0f82161e2565ea4a949f8d" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "secrets", "--install"
  end
end
