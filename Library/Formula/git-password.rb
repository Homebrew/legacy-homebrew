require 'formula'

class GitPassword < GithubGistFormula
  # Fork with fix for later Git versions
  url 'https://github.com/mrflip/git-password.git'
  sha1 'a31ed38cafd3a02b49fb4d5264353394fbdaf738'
  version '2012-04-10'

  homepage 'https://github.com/samuelkadolph/git-password'

  def install
    system "xcodebuild SYMROOT=build"
    system "mkdir -p #{bin}"
    system "cp build/Release/git-password #{bin}"
  end
end

