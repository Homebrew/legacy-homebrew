class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150803.tar.gz"
  sha256 "1759ee60c369c559403d1381b83452ca81cf62427de55bc32bce7b0a8e9b6990"

  head "https://github.com/sstephenson/ruby-build.git"

  bottle do
    cellar :any
    sha256 "c2c45eb6766603591c6b44110872e624ad3238c9ceea83502635492437715248" => :yosemite
    sha256 "f37e936dd4e135923efcc06f035299ab8bb3dd301bb8b6a82ec17b9d83ca76a8" => :mavericks
    sha256 "0723a94c6db9ca86bce08e64a4074a939ea764798cd1efb411c358048e9f5046" => :mountain_lion
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
