require "formula"

class RubyBuild < Formula
  head "https://github.com/sstephenson/ruby-build.git"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20140517.tar.gz"
  sha1 "a26aa68f444beaac5ea2c07dcb49803e667bbfae"

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
