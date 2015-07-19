class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150719.tar.gz"
  sha256 "b64110a7021575c5eff8da99c1178f18bd6b3858d60c5bee50a291fdec8cf965"

  head "https://github.com/sstephenson/ruby-build.git"

  bottle do
    cellar :any
    sha256 "ce607b76a4af929273a733171c9fb79cb37acecbe24c240facac2bcbc73951d8" => :yosemite
    sha256 "b4f25b3c8bf8adc4367955fb94ca59f2ecb6d777aae661dbe59776cd127cd577" => :mavericks
    sha256 "b114523afb6b27a37ad20b7279e9c970fa6eb418f066f64fa69efd829663e6ac" => :mountain_lion
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
