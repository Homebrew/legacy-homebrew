require "formula"

class RbenvBundlerRubyVersion < Formula
  homepage "https://github.com/aripollak/rbenv-bundler-ruby-version"
  url "https://github.com/aripollak/rbenv-bundler-ruby-version/archive/v0.1.tar.gz"
  sha1 "4a5190d896aaebdb103ffeae61dd4eace7c0fd4c"

  head "https://github.com/aripollak/rbenv-bundler-ruby-version.git"

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    (testpath/"Gemfile").write("ruby \"2.1.5\"")
    system "rbenv bundler-ruby-version"
  end
end
