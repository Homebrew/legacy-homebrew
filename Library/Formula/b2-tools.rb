class B2Tools < Formula
  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v0.4.0.tar.gz"
  sha256 "0253dfc4352ae6bc23e7184c2402b713f7e6f9a0584c80693ed1fdcffcf61325"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f279839417840e83dd562bbf5ec3e657045d32115671859a2f7e8c25a336479" => :el_capitan
    sha256 "8337d0e99a6691f551686d67c9af10fdb44dba88e3289cad3873fc4351198815" => :yosemite
    sha256 "e0f5d5b735ded6f83eae2d1debc2b78745f561bc27532f34d00fcf08028636d1" => :mavericks
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    bash_completion.install "contrib/b2" => "b2-tools-completion.bash"
  end

  test do
    assert_match "bad_auth_token",
      shell_output("#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY", 1)
  end
end
