require 'formula'

class Hk < Formula
  homepage 'https://hk.heroku.com/'
  url 'https://hk.heroku.com/hk-0.8-darwin-amd64.gz', :using => :nounzip
  version '0.8'
  sha1 'abcf44fa30d5dda19e65867d6578606436468b73'

  def install
    system "gunzip -c hk-0.8-darwin-amd64.gz > hk"
    system "chmod +x hk"
    bin.install'hk'
  end

  def test
    system "hk"
  end
end
