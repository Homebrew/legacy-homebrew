require 'formula'

class CloudfoundryCli < Formula
  homepage 'https://github.com/cloudfoundry/cli'
  head 'https://github.com/cloudfoundry/cli.git', :branch => 'master'
  url 'https://github.com/cloudfoundry/cli.git', :tag => 'v6.1.1'

  bottle do
    sha1 "f72539292f35aa0c7e66536494b895253cd3a667" => :mavericks
    sha1 "c43cb7af262a83f0aaf330fafd6c6be61afb01e9" => :mountain_lion
    sha1 "1d2942622b9571874910314c8d89fb0c837eaf47" => :lion
  end

  depends_on 'go' => :build

  def install
    inreplace 'src/cf/app_constants.go', 'BUILT_FROM_SOURCE', "#{version}-homebrew"
    inreplace 'src/cf/app_constants.go', 'BUILT_AT_UNKNOWN_TIME', Time.now.utc.iso8601
    system 'bin/build'
    bin.install 'out/cf'
    doc.install 'LICENSE'
  end

  test do
    system "#{bin}/cf"
  end
end
