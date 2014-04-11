require 'formula'

class CloudfoundryCli < Formula
  homepage 'https://github.com/cloudfoundry/cli'
  head 'https://github.com/cloudfoundry/cli.git', :branch => 'master'
  url 'https://github.com/cloudfoundry/cli.git', :tag => 'v6.1.0'

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
