require "formula"

class RubyBuild < Formula
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150319zf.tar.gz"
  sha256 "5c6c34aad60df2b93e30fc2263fa400bfe20cbd4e2ceaf497431fb3568bdb738"
  version "20150319zf"

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
