require "formula"

class RubyBuild < Formula
  head "https://github.com/sstephenson/ruby-build.git"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20140524.tar.gz"
  sha1 "a44e19bd6eb610d51d3b4d87961b2ea3a7126f3e"

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
