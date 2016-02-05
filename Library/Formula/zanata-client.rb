class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/3.8.1/zanata-cli-3.8.1-dist.tar.gz"
  sha256 "cc4ecfa2d530ff314076bd0173bdf829824737d48d4f4a2f4ca18d263e9da7c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e0cef73202011c4e5f72396a86b197292136ac4c51474853167a8f3cd2d5f40" => :el_capitan
    sha256 "d77b7008d3f2f22be8430c58b4fb18839b1740e6752607e4cb9a1f314e24d91c" => :yosemite
    sha256 "7ff54b8ca01393f2c85e30c595572c04fcc903838ede194325914b183e9f9c00" => :mavericks
  end

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    (bin/"zanata-cli").write_env_script libexec/"bin/zanata-cli", Language::Java.java_home_env("1.8+")
    bash_completion.install libexec/"bin/zanata-cli-completion"
  end

  test do
    assert_match /Zanata Java command-line client/, shell_output("#{bin}/zanata-cli --help")
  end
end
