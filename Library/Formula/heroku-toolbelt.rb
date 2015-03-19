require 'formula'

class HerokuToolbelt < Formula
  homepage 'https://toolbelt.heroku.com/other'
  url 'https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.28.1.tgz'
  sha1 'fb50b8159e34cb7a42aabbe9794891020a5ba3f9'

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  test do
    system "#{bin}/heroku", "version"
  end
end
