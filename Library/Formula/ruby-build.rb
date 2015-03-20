require "formula"

class RubyBuild < Formula
  head "https://github.com/sstephenson/ruby-build.git"
  homepage "https://github.com/sstephenson/ruby-build"
  sha1 "31c2e082b3fc82e90f86ff787184ecf0f9ace659"
  url "https://github.com/sstephenson/ruby-build/archive/v20150319zf.tar.gz"
  version "20150319zf"

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
