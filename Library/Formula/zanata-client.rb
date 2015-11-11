class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/3.7.4/zanata-cli-3.7.4-dist.tar.gz"
  sha256 "4424322bffb81f5185f87d1f11c7e92cde504c736695dbb4ced5854e49672037"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cd3c3ec928f0edf5a47f3b8e707dd2f2b1b2cd537745be7b14f837486921eef" => :el_capitan
    sha256 "e1a0a01dc59212ae3c6ac8fd55517d5c914b15ee26b6ca21b757ac747486a16f" => :yosemite
    sha256 "db3d050b39b9dfc4a47c53f86196ff4f0f129c5afcd730b7e4d6f3fae1a54b17" => :mavericks
  end

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]
    (bin/"zanata-cli").write_env_script libexec/"bin/zanata-cli", Language::Java.java_home_env("1.7+")
    bash_completion.install libexec/"bin/zanata-cli-completion"
  end

  test do
    assert_match /Zanata Java command-line client/, shell_output("#{bin}/zanata-cli --help")
  end
end
