class HerokuToolbelt < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://toolbelt.heroku.com/other"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.42.33.tgz"
  sha256 "10d51444f14236032217a57d659a8d5e83a20c37af34bc718320696c6f645134"
  head "https://github.com/heroku/heroku.git"

  bottle :unneeded

  depends_on :arch => :x86_64
  depends_on :ruby => "1.9"

  def install
    libexec.install Dir["*"]
    # turn off autoupdates (off by default in HEAD)
    if build.stable?
      inreplace libexec/"bin/heroku", "Heroku::Updater.inject_libpath", "Heroku::Updater.disable(\"Use `brew upgrade heroku-toolbelt` to update\")"
    end
    bin.write_exec_script libexec/"bin/heroku"
  end

  test do
    system "#{bin}/heroku", "version"
  end
end
