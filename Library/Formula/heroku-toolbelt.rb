class HerokuToolbelt < Formula
  homepage "https://toolbelt.heroku.com/other"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.36.4.tgz"
  sha256 "b57a991828663e3587e07a66b796bf56bf8f4610a618241195bd760a4cf29319"
  head "https://github.com/heroku/heroku.git"

  bottle do
    cellar :any
    sha256 "f5ca85f9fa06000417981d6b7e0442eeea5b9d43ac0efe0be1a66803943b960d" => :yosemite
    sha256 "b4c3d2200b49e798b507e2d39b062da20b951aee637484ddf65a7d98261118e5" => :mavericks
    sha256 "3dc678678593f75e0ac0ba8862004e1fa9e857b2a39dfc46d4cca230c53f95fe" => :mountain_lion
  end

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
