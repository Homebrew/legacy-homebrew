class DropboxUploader < Formula
  desc "Bash script for interacting with Dropbox"
  homepage "http://www.andreafabrizi.it/?dropbox_uploader"
  url "https://github.com/andreafabrizi/Dropbox-Uploader/archive/0.16.tar.gz"
  sha256 "738aebdb57f75e9033cb9bb319b14fe1c3b471f951180acb48631e9810ebf1c3"

  bottle :unneeded

  def install
    bin.install "dropbox_uploader.sh"
  end

  test do
    (testpath/".dropbox_uploader").write <<-EOS.undent
      APPKEY=a
      APPSECRET=b
      ACCESS_LEVEL=sandbox
      OAUTH_ACCESS_TOKEN=c
      OAUTH_ACCESS_TOKEN_SECRET=d
    EOS
    pipe_output("#{bin}/dropbox_uploader.sh unlink", "y\n")
  end
end
