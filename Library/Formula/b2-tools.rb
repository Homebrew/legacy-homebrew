class B2Tools < Formula
  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v0.3.12.tar.gz"
  sha256 "6c382d211c5df09477d5df468e43fe5b9691e44edfb5df9694e9b747a488d362"

  def install
    bin.install "b2"
    bash_completion.install "contrib/b2" => "b2-tools-completion.bash"
  end

  test do
    assert_match "bad_auth_token",
      shell_output("#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY", 1)
  end
end
