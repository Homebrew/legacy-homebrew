require "formula"

class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.4.0.tar.gz"
  sha1 "142859ba1eb9385fa78d936ad4efd62584bd618b"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any
    sha256 "c0c9c72e201561ad39f5a3a75b2df8ec4de02c10c7ba0d4a322c3bce2b41d7e5" => :yosemite
    sha256 "09c7ca22267c70e5c9e7382aec49a74ade8723df7c94a5d7b13ef5f8864fed64" => :mavericks
    sha256 "c8591b8d83a21737899487c461ee856a768b024bf58dfc76a0f0331757884c7a" => :mountain_lion
  end

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/gist", "--version"
  end
end
