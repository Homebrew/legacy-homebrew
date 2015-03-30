class HerokuToolbelt < Formula
  homepage "https://toolbelt.heroku.com/other"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.30.3.tgz"
  sha256 "2efc28e0af3e9e03ef98ba3530d0b5346a8221989c9e01e78d9944ea35013455"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  test do
    system "#{bin}/heroku", "version"
  end
end
