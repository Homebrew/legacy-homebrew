class RbenvBundlerRubyVersion < Formula
  desc "Pick a ruby version from bundler's Gemfile"
  homepage "https://github.com/aripollak/rbenv-bundler-ruby-version"
  url "https://github.com/aripollak/rbenv-bundler-ruby-version/archive/v0.3.1.tar.gz"
  sha256 "dfe9d2b79591a022d0185e20a5847e62999dcb51d4b1604f4a5527b6f9b88a8e"
  head "https://github.com/aripollak/rbenv-bundler-ruby-version.git"

  bottle :unneeded

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    (testpath/"Gemfile").write("ruby \"2.1.5\"")
    system "rbenv", "bundler-ruby-version"
  end
end
