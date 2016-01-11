class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20151230.tar.gz"
  sha256 "40c5cb4e4374589d3974ac6f63b6cb16a3ed2639f68f7133a610ee8e844b4b0f"

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
