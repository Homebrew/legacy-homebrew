require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/standalone'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-3.2.2.tgz'
  sha1 '99643a634ce70d9d778c240c8d5bc8d91429997a'

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  def test
    system "#{bin}/heroku", "version"
  end
end
