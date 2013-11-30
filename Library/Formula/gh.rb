require "formula"

class Gh < Formula
  VERSION = "0.25.1"
  ARCH = if MacOS.prefer_64_bit?
           "amd64"
         else
           "386"
         end

  homepage "https://github.com/jingweno/gh"
  head "https://github.com/jingweno/gh.git"
  url "https://github.com/jingweno/gh/releases/download/v#{VERSION}/gh_#{VERSION}-snapshot_darwin_#{ARCH}.zip"
  sha1 'f7f5fe32d9c96ed2b134bdb18671602255458874'
  version VERSION

  def install
    bin.install "gh"
    bash_completion.install "gh.bash_completion.sh"
    zsh_completion.install "gh.zsh_completion" => "_gh"
  end

  test do
    assert_equal VERSION, `#{bin}/gh version`.split.last
  end
end
