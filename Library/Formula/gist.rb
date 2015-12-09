class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.5.0.tar.gz"
  sha256 "f1060820a87bdc28b9e81f321d07e4b68604d3b84d6bf52a4422606fce34ed5f"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2412d7a6ab8631910becf70fc6749b9746da002145582b0ad9fbbf225ba31369" => :el_capitan
    sha256 "365a758d97ee79f1601d36848f8efb2b5466eb70256ef2ad78129169cc363c0b" => :yosemite
    sha256 "83e5d999746477c29d8d42f9e16554d248a97528abc311ab3bd880f819ccc94c" => :mavericks
  end

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    assert_match %r{https:\/\/gist}, pipe_output("#{bin}/gist", "homebrew")
  end
end
