require 'formula'

class Cf < Formula
  homepage 'https://github.com/cloudfoundry/cli'
  url 'https://github.com/cloudfoundry/cli.git', :tag => 'v6.0.0'
  version '6.0.0-beta'

  head 'https://github.com/cloudfoundry/cli.git', :branch => 'master'

  depends_on 'go' => :build

  def install
    system 'sed -i "" -e "s/SHA/homebrew/g" src/cf/app_constants.go'
    system 'bin/build'
    bin.install 'out/cf'
    doc.install 'LICENSE'
  end

  test do
    system "#{bin}/cf"
  end
end
