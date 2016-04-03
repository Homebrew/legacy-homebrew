class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.11.0", :revision => "6415bc91fde389c9b4866e2b61e1189be4c9796c"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "1bda0fb0e9b44be800aa7533ea4ea374ac24d211d4d0ba694272219e0f212b3c" => :el_capitan
    sha256 "3f4b1800796273788fd4d22329927aeca7f3fed0db616b700d3804ee37b9c5ab" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end
