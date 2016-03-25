class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.1.4",
    :revision => "3941102b8a022b5f2d9ec2c94d1f13d519fa9c31"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1437f92fe5b2d09273068c623ee2a6bca67a97e4c52bfa0bddaff4dce2f00c4b" => :el_capitan
    sha256 "c9acbb6246d196bdc9f4d3bac2110551835f2e1597942cb94429a9fdd7ffd437" => :yosemite
    sha256 "cd56908b06507599caf52db95ebae58e3a9f9a5a7ea9e14703bc3a24501fc700" => :mavericks
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
