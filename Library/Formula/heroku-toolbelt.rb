class HerokuToolbelt < Formula
  homepage "https://toolbelt.heroku.com/other"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.30.4.tgz"
  sha256 "51a92e85994c65d016823ad7b8fa74bf30ddeb59afb33751c1f93e8105c80e9e"
  head "https://github.com/heroku/heroku.git"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  test do
    system "#{bin}/heroku", "version"
  end
end
