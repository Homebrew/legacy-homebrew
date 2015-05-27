require "language/go"

class Gcsfuse < Formula
  desc "A user-space file system for interacting with Google Cloud Storage"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.1.1.tar.gz"
  sha256 "cc3c12dc82a8e9ff0672976131b60af4161606c082f8dfe9cc51730caf4f3123"

  bottle do
    cellar :any
    sha256 "56c8618fe16d0336b0c8dbd7882f5c33669f8e5d07d8a4dd779db97578d582ca" => :mavericks
    sha256 "9c014ddaafe37faf831f8f09809bbad99cd945f5863d3db6dce3e51e5d1e1e17" => :mountain_lion
  end

  depends_on :osxfuse
  depends_on "go" => :build

  go_resource "github.com/jacobsa/bazilfuse" do
    url "https://github.com/jacobsa/bazilfuse.git",
        :revision => "0ecedd83db5ab023bda2af4217a6a43fa9e0fd3d"
  end

  go_resource "github.com/jacobsa/fuse" do
    url "https://github.com/jacobsa/fuse.git",
        :revision => "d8008607135912a7682aadeeedcc283c76975320"
  end

  go_resource "github.com/jacobsa/gcloud" do
    url "https://github.com/jacobsa/gcloud.git",
        :revision => "89fb1940659c49c1de84cea15061ebfec65d94f0"
  end

  go_resource "github.com/jacobsa/oglematchers" do
    url "https://github.com/jacobsa/oglematchers.git",
        :revision => "3ecefc49db07722beca986d9bb71ddd026b133f0"
  end

  go_resource "github.com/jacobsa/reqtrace" do
    url "https://github.com/jacobsa/reqtrace.git",
        :revision => "245c9e0234cb2ad542483a336324e982f1a22934"
  end

  go_resource "github.com/jacobsa/util" do
    url "https://github.com/jacobsa/util.git",
        :revision => "72fcc8628ce3fceba2ccb4a443015bee085cd7a4"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net",
        :revision => "621fff363a1d9ad7fdd0bfa9d80a42881267deb4", :using => :git
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2",
        :revision => "36ff901f7b5bce4fa4f23b4e0e02ab9a70ebf3ec", :using => :git
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys",
        :revision => "58e109635f5d754f4b3a8a0172db65a52fcab866", :using => :git
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client",
        :revision => "d56f328dc27a4097cd0fc535e7c77807f48a2e84", :using => :git
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud",
        :revision => "5a049ccadb4555e68e9b7ed0a86f79c147bc8e7b", :using => :git
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    # Make the gcsfuse source code from the tarball appear in the appropriate
    # place in the $GOPATH workspace, then build the binaries with names that
    # don't conflict with directory names.
    mkdir_p "src/github.com/googlecloudplatform"
    ln_s buildpath, "src/github.com/googlecloudplatform/gcsfuse"
    system "go", "build", "-o", "gcsfuse.bin"
    system "go", "build", "-o", "gcsfuse_mount_helper.bin", "./gcsfuse_mount_helper"

    bin.install "gcsfuse.bin" => "gcsfuse"
    bin.install "gcsfuse_mount_helper.bin" => "gcsfuse_mount_helper"
  end

  test do
    system bin/"gcsfuse", "--help"
    system bin/"gcsfuse_mount_helper", "--help"
  end
end
