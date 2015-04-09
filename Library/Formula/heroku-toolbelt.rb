class Ruby19 < Requirement
  fatal true
  default_formula "ruby"

  satisfy :build_env => false do
    next unless which "ruby"
    version = /\d\.\d/.match `ruby --version 2>&1`
    next unless version
    Version.new(version.to_s) >= Version.new("1.9")
  end

  env do
    ENV.prepend_path "PATH", which("ruby").dirname
  end

  def message; <<-EOS.undent
    The Heroku Toolbelt needs Ruby >=1.9
    EOS
  end
end

class HerokuToolbelt < Formula
  homepage "https://toolbelt.heroku.com/other"
  url "https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client-3.31.2.tgz"
  sha256 "8e859fc1f95508ddfb4684f752ced4c2876aa94839830619ec659f83d72050fd"
  head "https://github.com/heroku/heroku.git"

  depends_on Ruby19

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/heroku"
  end

  test do
    system "#{bin}/heroku", "version"
  end
end
