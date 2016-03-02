class DropboxUploader < Formula
  desc "Bash script for interacting with Dropbox"
  homepage "http://www.andreafabrizi.it/?dropbox_uploader"
  url "https://github.com/andreafabrizi/Dropbox-Uploader/archive/0.16.tar.gz"
  sha256 "738aebdb57f75e9033cb9bb319b14fe1c3b471f951180acb48631e9810ebf1c3"

  def install
    bin.install "dropbox_uploader.sh"
  end

  test do
    (testpath/".dropbox_uploader").write("APPKEY=a\nAPPSECRET=b\nACCESS_LEVEL=sandbox\nOAUTH_ACCESS_TOKEN=c\nOAUTH_ACCESS_TOKEN_SECRET=d")
    system("yes | dropbox_uploader.sh unlink")
  end
end
