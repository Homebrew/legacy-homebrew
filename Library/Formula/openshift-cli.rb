class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.1.3",
    :revision => "cffae0523cfa80ddf917aba69f08508b91f603d5"

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
    (buildpath/".git/info/exclude").atomic_write <<-EOF.undent
      /.brew_home
      /src
    EOF

    # this is a terrible hack that's necessary because the build script assumes
    # that the source code was checked out via `go get` and overrides $GOPATH,
    # and also because make will change into the target of folder symlinks
    # rather than the folder symlinks themselves
    real_buildpath = buildpath/"src/github.com/openshift/origin"
    real_buildpath.install (Dir["*", ".*"] - [".", "..", "src"])

    system "make", "-C", "src/github.com/openshift/origin", "all", "WHAT=cmd/openshift", "GOFLAGS=-v"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install real_buildpath/"_output/local/bin/darwin/#{arch}/openshift"
    bin.install_symlink "openshift" => "oc"
    bin.install_symlink "openshift" => "oadm"

    bash_completion.install Dir[real_buildpath/"contrib/completions/bash/*"]
  end

  test do
    assert_match /^oc v#{version}$/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}$/, shell_output("#{bin}/oadm version")
    assert_match /^openshift v#{version}$/, shell_output("#{bin}/openshift version")
  end
end
