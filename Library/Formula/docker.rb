require "formula"

class Docker < Formula
  homepage "http://docker.io"
  url "https://github.com/dotcloud/docker.git", :tag => "v0.11.1"

  bottle do
    sha1 "2a97dab4bb3109c57ed99144feb3d2bad6588b2c" => :mavericks
    sha1 "0013849c9ab2b85374a944e25c42f974ee986911" => :mountain_lion
    sha1 "a9a6021d388f1b004f262977968ed727c4aea022" => :lion
  end

  option "without-completions", "Disable bash/zsh completions"
  option "without-netgo", "Disable netgo tag (required for mDNS)"

  depends_on "go" => :build

  patch :DATA if build.without? "netgo"

  def install
    ENV["GIT_DIR"] = cached_download/".git"
    ENV["AUTO_GOPATH"] = "1"
    ENV["DOCKER_CLIENTONLY"] = "1"

    system "hack/make.sh", "dynbinary"
    bin.install "bundles/#{version}/dynbinary/docker-#{version}" => "docker"

    if build.with? "completions"
      bash_completion.install "contrib/completion/bash/docker"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    system "#{bin}/docker", "--version"
  end
end

__END__
diff --git a/hack/make.sh b/hack/make.sh
index 8636756..3f379ca 100755
--- a/hack/make.sh
+++ b/hack/make.sh
@@ -96,7 +96,7 @@ LDFLAGS='
 '
 LDFLAGS_STATIC='-linkmode external'
 EXTLDFLAGS_STATIC='-static'
-BUILDFLAGS=( -a -tags "netgo static_build $DOCKER_BUILDTAGS" )
+BUILDFLAGS=( -a -tags "static_build $DOCKER_BUILDTAGS" )
 
 # A few more flags that are specific just to building a completely-static binary (see hack/make/binary)
 # PLEASE do not use these anywhere else.

