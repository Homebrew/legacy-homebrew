class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150818.tar.gz"
  sha256 "692df6287b172d12adbc13b58074075f8c6df7807a4b30e33baf74e3c528f9ae"

  head "https://github.com/sstephenson/ruby-build.git"

  bottle do
    cellar :any
    sha256 "db4d6cdc4df9f5aa35401c8bda7350f6102547e51a6a03ae566c4d80ad4e5252" => :yosemite
    sha256 "ec327bbd77d3ffd3d61d8d76281ef49d6ddf3617e82345d0755e046aba11c1b1" => :mavericks
    sha256 "3a8e9b41353761ffde1118c7759913b002a4b2a6f098e5cded3c28efa5717cc6" => :mountain_lion
  end

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
