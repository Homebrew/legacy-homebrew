class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/3.7.4/zanata-cli-3.7.4-dist.tar.gz"
  sha256 "4424322bffb81f5185f87d1f11c7e92cde504c736695dbb4ced5854e49672037"

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]
    (bin/"zanata-cli").write_env_script libexec/"bin/zanata-cli", Language::Java.java_home_env("1.7+")
    bash_completion.install libexec/"bin/zanata-cli-completion"
  end

  test do
    assert_match /Zanata Java command-line client/, shell_output("zanata-cli --help")
  end
end
