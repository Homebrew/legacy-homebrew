require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-2.40.0.tgz'
  sha1 '8ab041df01346427aeedd2bfe2c8900be7f3b390'

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  def test
    system "#{bin}/heroku", "version"
  end
end
