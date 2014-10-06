require "formula"

class RubyBuild < Formula
  head "https://github.com/sstephenson/ruby-build.git"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20140926.tar.gz"
  sha1 "b48868b13db871af043d01ec77d3deab61159433"

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
