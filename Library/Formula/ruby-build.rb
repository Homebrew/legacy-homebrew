require "formula"

class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150709.tar.gz"
  sha256 "dff8350bd6ad6da4853c8a074aa77ebe7525410306bc0bb58d91d12888c9421f"

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
