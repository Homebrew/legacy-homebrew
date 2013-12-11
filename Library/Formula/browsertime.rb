require 'formula'

class Browsertime < Formula
  homepage 'http://browsertime.net'
  url 'https://github.com/tobli/browsertime/releases/download/browsertime-0.4/browsertime-0.4.zip'
  sha1 'b62d3b5eff94a0ab04c8359dfd36086f7573c8ac'

  depends_on 'chromedriver'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "browsertime", "--version"
  end
end
