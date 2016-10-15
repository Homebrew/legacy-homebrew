require "formula"

class Bookmark < Formula
  homepage "https://github.com/pratik60/bookmark"
  url "https://github.com/pratik60/bookmark/archive/v1.1.tar.gz"
  head "https://github.com/pratik60/bookmark.git", :branch => "master"
  sha1 "28155f3c1e4e3873e205821770708a9681414890"

  def install
    bin.install 'bookmarker.sh'
  end

  def caveats; <<-EOS.undent
    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):
      [[ -s `brew --prefix`/bin/bookmarker.sh ]] && . `brew --prefix`/bin/bookmarker.sh
    EOS
  end

end
