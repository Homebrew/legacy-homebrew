require "formula"

class CloudfoundryCli < Formula
  homepage "https://github.com/cloudfoundry/cli"
  head "https://github.com/cloudfoundry/cli.git", :branch => "master"
  url "https://github.com/cloudfoundry/cli/archive/v6.1.2.tar.gz"
  sha1 "33b3d78929dc145b5d01f48e8c700d77c577ec8e"

  depends_on "go" => :build

  # Remove godep from build script.  This patch can be removed once #180 has been merged and a release beyond v6.1.2
  # has been created.
  # https://github.com/cloudfoundry/cli/pull/180
  stable do
    patch do
      url "https://github.com/nebhale/cli/commit/6e207befbca7d9d8a234cb01b9a04c557b896a1c.diff"
      sha1 "c1e3a8f2930fe08df5db8d54b2e17dffa393dcd6"
    end
  end

  # Remove godep from build script.  This patch can be removed once #180 has been merged.
  # https://github.com/cloudfoundry/cli/pull/180
  head do
    patch do
      url "https://github.com/cloudfoundry/cli/pull/180.diff"
      sha1 "f30ab1e2e04503cef8e9fb922affe9222a872972"
    end
  end

  def install
    cli_source = buildpath + "src/github.com/cloudfoundry/cli"

    # Building this project "assumes you are working in a standard Go workspace, as described in
    # http://golang.org/doc/code.html". This code moves the source code, as presented by Homebrew, into the proper
    # location to meet this requirement.
    source_files = Dir["*"]
    mkdir_p cli_source
    mv source_files, cli_source

    Dir.chdir cli_source do
      inreplace "cf/app_constants.go", "BUILT_FROM_SOURCE", "#{version}-homebrew"
      inreplace "cf/app_constants.go", "BUILT_AT_UNKNOWN_TIME", Time.now.utc.iso8601
      system "bin/build"
      bin.install "out/cf"
      doc.install "LICENSE"
    end
  end

  test do
    system "#{bin}/cf"
  end
end
