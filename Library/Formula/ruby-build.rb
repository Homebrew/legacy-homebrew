class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20160111.tar.gz"
  sha256 "13cfd535e3a3fdcc87756e3f2f71989ea9f668aa3a474b4640170b4a248c2a37"

  bottle :unneeded

  head "https://github.com/rbenv/ruby-build.git"

  depends_on "autoconf" => [:recommended, :run]
  depends_on "pkg-config" => [:recommended, :run]
  depends_on "openssl" => :recommended

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/ruby-build", "--definitions"
  end
end
