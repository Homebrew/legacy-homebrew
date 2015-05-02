require "formula"

class RubyBuild < Formula
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150502.tar.gz"
  sha256 "e37e8d4390e34987b3270a161d9cafbd185741f11f9e40035d3ab1ee0bad559d"

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
