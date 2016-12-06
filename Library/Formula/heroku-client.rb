require 'formula'

class HerokuClient < Formula
  url 'http://assets.heroku.com/heroku-client/heroku-client.tgz'
  homepage ''
  md5 'f8792e8b084bbc4d0153f845b638cacc'
  version '2.11.0'

  def install
    prefix.install Dir['*']
    system "rm /usr/local/bin/heroku"
    system "ln -s #{prefix}/heroku #{HOMEBREW_PREFIX}/bin/heroku"
  end

  def test
    system "heroku"
  end
end
