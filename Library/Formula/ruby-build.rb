require "formula"

class RubyBuild < Formula
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150413.tar.gz"
  sha256 "a07e1b31df730be9a7be64036fe89a06f0ce41dc6c1cd79c69f7aef08091d140"

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
