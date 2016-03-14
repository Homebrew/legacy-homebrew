class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.1.4",
    :revision => "3941102b8a022b5f2d9ec2c94d1f13d519fa9c31"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b435d2e26244ce987172be109b6a5b3ab9ebc13125a7eb197830a6e4dd1cf6b" => :el_capitan
    sha256 "508eaa170f5c8f240e49e9e5487238272f5b06b38eb8cede50304bd8ea2620e8" => :yosemite
    sha256 "1d61368ef89aed53970254b0f3e83dc673b644296d8cf7c80e8efdb8fc27c68a" => :mavericks
  end

  depends_on "go" => :build

  def install
    # this is necessary to avoid having the version marked as dirty
    (buildpath/".git/info/exclude").atomic_write "/.brew_home"

    system "make", "all", "WHAT=cmd/openshift", "GOFLAGS=-v", "OS_OUTPUT_GOPATH=1"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/openshift"
    bin.install_symlink "openshift" => "oc"
    bin.install_symlink "openshift" => "oadm"

    bash_completion.install Dir["contrib/completions/bash/*"]
  end

  test do
    assert_match /^oc v#{version}$/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}$/, shell_output("#{bin}/oadm version")
    assert_match /^openshift v#{version}$/, shell_output("#{bin}/openshift version")
  end
end
