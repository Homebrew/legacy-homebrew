require "formula"

class RubyBuild < Formula
  head "https://github.com/sstephenson/ruby-build.git"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20140918.tar.gz"
  sha1 "8abfae48d7e56441cef5f70c10d166721b875079"

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
