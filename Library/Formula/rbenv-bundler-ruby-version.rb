class RbenvBundlerRubyVersion < Formula
  desc "Pick a ruby version from bundler's Gemfile"
  homepage "https://github.com/aripollak/rbenv-bundler-ruby-version"
  url "https://github.com/aripollak/rbenv-bundler-ruby-version/archive/v0.2.tar.gz"
  sha256 "b6abca1097bd9e99be89dd46e7bd855f47c6522c97546e43049cf38f6aea6c9a"
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
