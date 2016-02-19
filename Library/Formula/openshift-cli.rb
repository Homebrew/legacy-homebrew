class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.1.3",
    :revision => "cffae0523cfa80ddf917aba69f08508b91f603d5"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c8ca59585e6ebb0f7f710e8d93617df2389b6b7f182c8b8cb7ebbf9ed39d305" => :el_capitan
    sha256 "3054a67ded7f2f0053dc25bc9095b38d35f37ae914ffa6718e3c15146fb70654" => :yosemite
    sha256 "0f7135b14b18808b401a8a9d53fea956c875622ccd3d156b90657703bf739c89" => :mavericks
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
