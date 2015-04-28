class HerokuToolbelt < Formula
  homepage "https://toolbelt.heroku.com/other"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.32.0.tgz"
  sha256 "bae8e899dbc0f2e341171e10270faa347b1d4e9dda31167b091d6a4e6dfd2695"
  head "https://github.com/heroku/heroku.git"

  depends_on :ruby => "1.9"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  test do
    system "#{bin}/heroku", "version"
  end
end
