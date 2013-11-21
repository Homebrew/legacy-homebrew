require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-3.0.1.tgz'
  sha1 '11a70ecbb686c187be8502814e9249f4970163e3'

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  def test
    system "#{bin}/heroku", "version"
  end
end
