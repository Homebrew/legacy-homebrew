require 'formula'

class S3cmd < Formula
  homepage 'http://s3tools.org/s3cmd'
  url 'https://downloads.sourceforge.net/project/s3tools/s3cmd/1.5.0/s3cmd-1.5.0.tar.gz'
  sha1 '53ebc485329cb15cad8f61ca0c8c2d06563ee2f3'
  head 'https://github.com/s3tools/s3cmd.git'

  bottle do
    cellar :any
    sha1 "254a78674d86587e18419099e20059c61b5a257a" => :yosemite
    sha1 "03ec4493b583447b5e0db95f8b98066866920ce8" => :mavericks
    sha1 "ec0dd6f3298c8b8aa5dab60e395d7c013a6747c9" => :mountain_lion
  end

  def install
    libexec.install 's3cmd', 'S3'
    man1.install 's3cmd.1'
    bin.install_symlink libexec+'s3cmd'
  end
end
