require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-2.39.5.tgz'
  sha1 'e2422a3e781766661b7ba38dada1ab785dcbc542'

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
