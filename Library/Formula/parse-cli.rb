class ParseCli < Formula
  homepage "https://parse.com"
  url "https://www.parse.com/downloads/cloud_code/parse",
    :using  => :nounzip
  sha1 "b59d6ebf45bff657cbd743bc76191098da17ce02"
  version "1.4.1"

  def install
    chmod 0755, "parse"
    bin.install "parse" => "parse"
  end

  test do
    version_str = pipe_output("#{bin}/parse |grep Version")
    assert_equal "Version #{version}", version_str
  end
end
