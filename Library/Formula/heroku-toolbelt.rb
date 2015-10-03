class HerokuToolbelt < Formula
  desc "Everything you need to get started with Heroku"
  homepage "https://toolbelt.heroku.com/other"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.42.10.tgz"
  sha256 "fb979a603e955bd5f6561ad2bb1b8e88bec2c57d844264671323690f770d76f4"
  head "https://github.com/heroku/heroku.git"

  depends_on :ruby => "1.9"

  def install
    libexec.install Dir["*"]
    # turn off autoupdates (off by default in HEAD)
    if build.stable?
      inreplace libexec/"bin/heroku", "Heroku::Updater.inject_libpath", "Heroku::Updater.disable(\"Use `brew upgrade heroku-toolbelt` to update\")"
    end
    bin.write_exec_script libexec/"bin/heroku"
  end

  def caveats
    <<-EOS.undent
      Unlike the standalone download for Heroku Toolbelt, the Homebrew package
      does not come with Foreman. It is available via RubyGems, direct download,
      and other installation methods. See https://ddollar.github.io/foreman/ for more info.
    EOS
  end

  test do
    system "#{bin}/heroku", "version"
  end
end
