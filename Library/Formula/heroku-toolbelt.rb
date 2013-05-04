require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-2.37.2.tgz'
  sha1 '2a077d68f46948a83cfced0686309695302d1417'

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
