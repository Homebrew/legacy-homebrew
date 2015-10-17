require "language/go"

class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org"
  url "https://github.com/svent/sift/archive/v0.4.0.tar.gz"
  sha256 "6682b3eb08ae45eca8c6a09ef7811a79f6a9f244cdd06b76cd65eed956375b31"

  bottle do
    cellar :any_skip_relocation
    sha256 "468759cd724c11c568475a7f5a3572cb66d45746c0b42ff99b474ca1a97e3226" => :el_capitan
    sha256 "5f7356890eb2a1a102fee1fafbf101d229daea46bbfcc9ca1ad61e90595e68ef" => :yosemite
    sha256 "e7416798b373bc67b9aa68d1166ef8d0c1fd5e29389a2dacaebb26f2add53b1b" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/svent/go-flags" do
    url "https://github.com/svent/go-flags.git", :revision => "4bcbad344f0318adaf7aabc16929701459009aa3"
  end

  go_resource "github.com/svent/go-nbreader" do
    url "https://github.com/svent/go-nbreader.git", :revision => "7cef48da76dca6a496faa7fe63e39ed665cbd219"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"sift"
  end

  test do
    (testpath/"test.txt").write "where is foo"
    assert_match(/where is foo/, shell_output("#{bin/"sift"} foo #{testpath}"))
  end
end
