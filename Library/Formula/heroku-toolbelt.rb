require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-2.33.5.tgz'
  sha1 'da42fd5c23b54bc5e8239e9b4b0beb8524dc4d5f'

  def install
    libexec.install Dir["*"]
    (bin/'heroku').write <<-EOS.undent
      #!/usr/bin/env sh
      exec "#{libexec}/bin/heroku" "$@"
    EOS
  end

  def test
    system "#{bin}/heroku", "version"
  end
end
