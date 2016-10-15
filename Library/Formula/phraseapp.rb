class Phraseapp < Formula
  desc "PhraseApp CLI Tool - API client binary"
  homepage "https://phraseapp.com/cli"
  url "https://github.com/phrase/phraseapp-client/releases/download/1.0.1/phraseapp_macosx_amd64.tar.gz"
  version "1.0.1"
  sha256 "4b1aa4c36f7c92618904d6882817e8459e3420f146e4864555dbe6ab9b65a192"

  def install
    bin.install "phraseapp"
  end

  test do
    output = `#{bin}/phraseapp info`
    assert_match /Built at .+/, output
  end
end
