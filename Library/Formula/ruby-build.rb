require "formula"

class RubyBuild < Formula
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150506.tar.gz"
  sha256 "68bc8577897f0a7f76b02a7a666d613de9d15379f5b8b7c6f753c75bd9fade22"

  head "https://github.com/sstephenson/ruby-build.git"

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/ruby-build", "--version"
  end
end
