require 'formula'

class CloudfoundryCli < Formula
  homepage 'https://github.com/cloudfoundry/cli'
  head 'https://github.com/cloudfoundry/cli.git', :branch => 'master'
  url 'https://github.com/cloudfoundry/cli.git', :tag => 'v6.1.2'

  bottle do
    sha1 "f72539292f35aa0c7e66536494b895253cd3a667" => :mavericks
    sha1 "c43cb7af262a83f0aaf330fafd6c6be61afb01e9" => :mountain_lion
    sha1 "1d2942622b9571874910314c8d89fb0c837eaf47" => :lion
  end

  depends_on 'go' => :build
  depends_on :hg # Needed for Godep

  def install
    # Setup Directory to look like standard GOPATH
    files = Dir["#{buildpath}/*"].each do |file|
      (buildpath + "src/github.com/cloudfoundry/cli").install File.basename(file)
    end

    # Temporarily install godep
    ENV["GOPATH"] = buildpath
    system "go get github.com/tools/godep"
    ENV.append_path "PATH", "#{buildpath}/bin"

    # Use godep to get build dependencies
    Dir.chdir "#{buildpath}/src/github.com/cloudfoundry/cli"
    system "godep restore"

    # Add to the GOPATH via godep
    godep_path = `godep path`.chomp
    ENV["GOPATH"] = "#{godep_path}:#{buildpath}"

    inreplace 'cf/app_constants.go', 'BUILT_FROM_SOURCE', "#{version}-homebrew"
    inreplace 'cf/app_constants.go', 'BUILT_AT_UNKNOWN_TIME', Time.now.utc.iso8601

    system 'bin/build'
    bin.install 'out/cf'
    doc.install 'LICENSE'
  end

  test do
    system "#{bin}/cf"
  end
end
