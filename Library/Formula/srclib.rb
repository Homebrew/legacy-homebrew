require "language/go"

class Srclib < Formula
  desc "Polyglot code analysis library, built for hackability"
  homepage "https://srclib.org"
  url "https://github.com/sourcegraph/srclib/archive/v0.0.42.tar.gz"
  sha256 "de9af74ec0805b0ef4f1c7ddf26c5aef43f84668b12c001f2f413ff20a19ebee"
  revision 1
  head "https://github.com/sourcegraph/srclib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5a28e6c6995cd33047bf326d514fd0fd48656df2a8d2ade91f1adb9c0f65c73" => :el_capitan
    sha256 "76de11463b863eb4e2ccc31478aacc258de1449ebd237675312864e8db596c41" => :yosemite
    sha256 "2e8c68f8948ae220448400680108083931ca78273fd1f320b084879d14a567bb" => :mavericks
  end

  conflicts_with "src", :because => "both install a 'src' binary"

  depends_on :hg => :build
  depends_on "go" => :build

  go_resource "code.google.com/p/rog-go" do
    url "https://code.google.com/p/rog-go",
        :revision => "7088342b70fc1995ada4986ef2d093f340439c78", :using => :hg
  end

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus",
        :revision => "cdd90c38c6e3718c731b555b9c3ed1becebec3ba", :using => :git
  end

  go_resource "github.com/alecthomas/binary" do
    url "https://github.com/alecthomas/binary",
        :revision => "21c37b530bec7c512af0208bfb15f34400301682", :using => :git
  end

  go_resource "github.com/alecthomas/unsafeslice" do
    url "https://github.com/alecthomas/unsafeslice",
        :revision => "a2ace32dbd4787714f87adb14a8aa369142efac5", :using => :git
  end

  go_resource "github.com/aybabtme/color" do
    url "https://github.com/aybabtme/color",
        :revision => "28ad4cc941d69a60df8d0af1233fd5a2793c2801", :using => :git
  end

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker",
        :revision => "9c505c906d318df7b5e8652c37e4df06b4f30d56", :using => :git
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient",
        :revision => "ddb122d10f547ee6cfc4ea7debff407d80abdabc", :using => :git
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf",
        :revision => "bc946d07d1016848dfd2507f90f0859c9471681e", :using => :git
  end

  go_resource "github.com/google/go-querystring" do
    url "https://github.com/google/go-querystring",
        :revision => "d8840cbb2baa915f4836edda4750050a2c0b7aea", :using => :git
  end

  go_resource "github.com/gorilla/context" do
    url "https://github.com/gorilla/context",
        :revision => "215affda49addc4c8ef7e2534915df2c8c35c6cd", :using => :git
  end

  go_resource "github.com/inconshreveable/go-update" do
    url "https://github.com/inconshreveable/go-update",
        :revision => "68f5725818189545231c1fd8694793d45f2fc529", :using => :git
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext",
        :revision => "efacde03154693404c65e7aa7d461ac9014acd0c", :using => :git
  end

  go_resource "github.com/kr/binarydist" do
    url "https://github.com/kr/binarydist",
        :revision => "9955b0ab8708602d411341e55fffd7e0700f86bd", :using => :git
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs",
        :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b", :using => :git
  end

  go_resource "github.com/petar/GoLLRB" do
    url "https://github.com/petar/GoLLRB",
        :revision => "53be0d36a84c2a886ca057d34b6aa4468df9ccb4", :using => :git
  end

  go_resource "github.com/peterbourgon/diskv" do
    url "https://github.com/peterbourgon/diskv",
        :revision => "72aa5da9f7d1125b480b83c6dc5ad09a1f04508c", :using => :git
  end

  go_resource "github.com/peterh/liner" do
    url "https://github.com/peterh/liner",
        :revision => "1bb0d1c1a25ed393d8feb09bab039b2b1b1fbced", :using => :git
  end

  go_resource "github.com/smartystreets/mafsa" do
    url "https://github.com/smartystreets/mafsa",
        :revision => "ab6b5abc58c9d82560b127e23bfd3e39a25e8f05", :using => :git
  end

  go_resource "github.com/sourcegraph/go-github" do
    url "https://github.com/sourcegraph/go-github",
        :revision => "c6edc3e74760ee3c825f46ad9d4eb3e40469cb92", :using => :git
  end

  go_resource "github.com/sourcegraph/httpcache" do
    url "https://github.com/sourcegraph/httpcache",
        :revision => "e2fdd7ddabf459df5cd87bd18a4616ae7084763e", :using => :git
  end

  go_resource "github.com/sourcegraph/mux" do
    url "https://github.com/sourcegraph/mux",
        :revision => "dd22f369d469f65c3946889f5d8a1fb3933192e9", :using => :git
  end

  go_resource "github.com/sqs/fileset" do
    url "https://github.com/sqs/fileset",
        :revision => "4317e899aa9438ba7603a6e322389571cb3ffdff", :using => :git
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools",
        :revision => "a18bb1d557dac8d19062dd0240b44ab09cfa14fd", :using => :git
  end

  go_resource "sourcegraph.com/sourcegraph/go-diff" do
    url "https://github.com/sourcegraph/go-diff",
        :revision => "07d9929e8741ec84aa708aba12a4b1efd3a7a0dd", :using => :git
  end

  go_resource "sourcegraph.com/sourcegraph/go-flags" do
    url "https://github.com/sourcegraph/go-flags",
        :revision => "f59c328da6215a0b6acf0441ef19e361660ff405", :using => :git
  end

  go_resource "sourcegraph.com/sourcegraph/go-nnz" do
    url "https://github.com/sourcegraph/go-nnz",
        :revision => "62f271ba06026cf310d94721425eda2ec72f894c", :using => :git
  end

  go_resource "sourcegraph.com/sourcegraph/go-sourcegraph" do
    url "https://github.com/sourcegraph/go-sourcegraph",
        :revision => "6f1cd4d2b721cff7913ed2f04bcd820590ce3b94", :using => :git
  end

  go_resource "sourcegraph.com/sourcegraph/go-vcs" do
    url "https://github.com/sourcegraph/go-vcs",
        :revision => "1dcc4655df7318c3f105f9212900e1d0c68f7424", :using => :git
  end

  go_resource "sourcegraph.com/sourcegraph/makex" do
    url "https://github.com/sourcegraph/makex",
        :revision => "ba5e243479d710a5d378c97d007568a405d04492", :using => :git
  end

  go_resource "sourcegraph.com/sourcegraph/rwvfs" do
    url "https://github.com/sourcegraph/rwvfs",
        :revision => "451122bc19b9f1cdfeb2f1fdccadbc33ef5aa9f7", :using => :git
  end

  go_resource "sourcegraph.com/sourcegraph/vcsstore" do
    url "https://github.com/sourcegraph/vcsstore",
        :revision => "53d0c58fd11f7dc451456eb983050c58cd005268", :using => :git
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/sourcegraph.com/sourcegraph"
    ln_sf buildpath, buildpath/"src/sourcegraph.com/sourcegraph/srclib"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "cmd/src" do
      system "go", "build", "-o", "src"
      bin.install "src"
    end
  end

  # For test
  resource "srclib-sample" do
    url "https://github.com/sourcegraph/srclib-sample.git",
      :revision => "e753b113784bf383f627394e86e4936629a3b588"
  end

  test do
    resource("srclib-sample").stage do
      # Avoid automatic writing to $HOME/.srclib
      ENV["SRCLIBPATH"] = testpath
      ENV.prepend_path "PATH", bin
      system "#{bin}/src", "toolchain", "add", "--force", "sourcegraph.com/sourcegraph/srclib-sample"
      result = pipe_output("#{bin}/src api units")
      assert_match '"Type":"sample"', result
    end
  end
end
