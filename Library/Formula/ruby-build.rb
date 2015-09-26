class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150818.tar.gz"
  sha256 "692df6287b172d12adbc13b58074075f8c6df7807a4b30e33baf74e3c528f9ae"

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
