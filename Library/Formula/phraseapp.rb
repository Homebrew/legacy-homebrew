class Phraseapp < Formula
  desc "Command-line tool for PhraseApp localization service"
  homepage "http://docs.phraseapp.com/api/v2"
  url "https://github.com/phrase/phraseapp-client/releases/download/0.2.0.beta9/phraseapp_macosx_amd64.tar.gz"
  version "0.2.0.beta9"
  sha256 "e4e9f47a5cfc5c13cafa3a5f28f4873498eb46cf6fe2253d069c14a35c4a3e3d"

  def install
    bin.install "phraseapp"
  end

  test do
    output = `#{bin}/phraseapp help`
    assert_match /Built at .+/, output
  end
end
