class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.1.1.1",
    :revision => "940be513e42def2fdb3b83283d830d2c63abbad4"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbbdc3abc10d12dda8e1db85f9b140e337ba925151fd32c4a93a4af52d48997b" => :el_capitan
    sha256 "60f65184cd48a58dd0afbac64a64aba7b795b64a38b682b40edea3b653d0c6bb" => :yosemite
    sha256 "3ab7e60d60b20530e37ea3c7a468857a66e7b33dd974eaace646de7d628efe29" => :mavericks
  end

  depends_on "go" => :build

  def install
    # this is necessary to avoid having the version marked as dirty
    (buildpath/".git/info/exclude").atomic_write "/.brew_home"

    system "make", "all", "WHAT=cmd/openshift", "GOFLAGS=-v"

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
