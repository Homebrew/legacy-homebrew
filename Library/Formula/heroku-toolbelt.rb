require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-2.39.4.tgz'
  sha1 'b6764c20b5b820d55855795ac87f7efe79d30f8e'

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
