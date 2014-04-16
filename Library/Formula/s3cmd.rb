require 'formula'

class S3cmd < Formula
  homepage 'http://s3tools.org/s3cmd'
  url 'https://github.com/s3tools/s3cmd/archive/v1.0.1.tar.gz'
  sha1 '98ef9ea9e2dc56ab98f84610883d3d371c65e43a'
  head 'https://github.com/s3tools/s3cmd.git'

  devel do
    url 'https://github.com/s3tools/s3cmd/archive/v1.5.0-beta1.tar.gz'
    sha1 '3b5c299518cdfdd4adb81e843514865742082e82'
    version "1.5.0-beta1"
  end

  bottle do
    cellar :any
    sha1 "6504b103e65ce2dfdde9220a0f2b9033bf90bb5f" => :mavericks
    sha1 "59fbbbfc85dba185128e69b03f2c73ec96653bf9" => :mountain_lion
    sha1 "54e4d1c752eb3da312d05ce507d4979e8edb898f" => :lion
  end

  def install
    libexec.install 's3cmd', 'S3'
    man1.install 's3cmd.1'
    bin.install_symlink libexec+'s3cmd'
  end
end
