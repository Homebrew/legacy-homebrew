require "formula"

class Glide < Formula
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/releases/download/0.1.0/glide_mac_amd64.zip"
  sha1 "ddd3f899ce6382f9ae9da3c8255a3ffb2656cbc1"

  def install
    inreplace 'glide', '/usr/local', HOMEBREW_PREFIX
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    If you set your GOPATH in your shell's profile or RC scripts, you may
    need to tweak those settings. See the Troubleshooting guide at

      https://github.com/Masterminds/glide
    EOS
  end
end
