require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-3.3.0.tgz'
  sha1 '5c4760414623b3e92bb0deaf5d49da695f8c7ad4'

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  def test
    system "#{bin}/heroku", "version"
  end
end
