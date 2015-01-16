require 'formula'

class S3cmd < Formula
  homepage 'http://s3tools.org/s3cmd'
  url 'https://downloads.sourceforge.net/project/s3tools/s3cmd/1.5.0/s3cmd-1.5.0.tar.gz'
  sha1 '53ebc485329cb15cad8f61ca0c8c2d06563ee2f3'
  head 'https://github.com/s3tools/s3cmd.git'

  bottle do
    cellar :any
    revision 1
    sha1 "7493692a3dc0b34a8d3a617bd4e36df9fed16226" => :mavericks
    sha1 "5161ab336e7f34d8442b4a0c5964a99004ff03d9" => :mountain_lion
    sha1 "198a88c5490cdc705fee324a131a44360c826f63" => :lion
  end

  def install
    libexec.install 's3cmd', 'S3'
    man1.install 's3cmd.1'
    bin.install_symlink libexec+'s3cmd'
  end
end
