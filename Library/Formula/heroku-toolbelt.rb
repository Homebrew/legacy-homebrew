class HerokuToolbelt < Formula
  homepage "https://toolbelt.heroku.com/other"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.28.1.tgz"
  sha256 "2144310c37800d8f546015b773ad7e2b5d1b0a9dead246d0057a8fe85b9bf9cc"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  test do
    system "#{bin}/heroku", "version"
  end
end
