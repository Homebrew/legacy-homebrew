require 'formula'

class CloudfoundryCli < Formula
  homepage 'https://github.com/cloudfoundry/cli'
  head 'https://github.com/cloudfoundry/cli.git', :branch => 'master'
  url 'https://github.com/cloudfoundry/cli.git', :tag => 'v6.1.0'

  bottle do
    sha1 "5ce0c33f8057cfa5ba85a17fd6683b24158a0571" => :mavericks
    sha1 "c63fe614f058781e8523b5c1905a2ec0045dc89d" => :mountain_lion
    sha1 "11aede84b5e4f4656688f587d819e0b8b8cfd19e" => :lion
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
