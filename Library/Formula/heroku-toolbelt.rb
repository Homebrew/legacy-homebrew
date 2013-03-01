require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'http://assets.heroku.com.s3.amazonaws.com/heroku-client/heroku-client-2.34.0.tgz'
  sha1 'cc2616af9940516f3c265a27e740ae7b3c36eef8'

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
