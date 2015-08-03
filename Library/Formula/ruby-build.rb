class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/sstephenson/ruby-build"
  url "https://github.com/sstephenson/ruby-build/archive/v20150803.tar.gz"
  sha256 "1759ee60c369c559403d1381b83452ca81cf62427de55bc32bce7b0a8e9b6990"

  head "https://github.com/sstephenson/ruby-build.git"

  bottle do
    cellar :any
    sha256 "865a1dba53c766869b1a7c513512ce5d1c1947ef0694e50a1bea6235fd707f92" => :yosemite
    sha256 "ab8cba77b5ee960abbf189286e691cfa130ba4d25d9a4510fc70bbfe6d5a1fd6" => :mavericks
    sha256 "f7de92c3b4f8fdc014dc841a4986404be4a2dff81928e309fdaed900d7b243ed" => :mountain_lion
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
