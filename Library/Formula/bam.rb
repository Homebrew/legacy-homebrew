require 'formula'

class Bam < Formula
  homepage 'http://matricks.github.com/bam/'
  url 'https://github.com/downloads/matricks/bam/bam-0.4.0.tar.gz'
  sha1 'c0f32ff9272d5552e02a9d68fbdd72106437ee69'

  head 'https://github.com/matricks/bam.git'

  def install
    system "./make_unix.sh"
    bin.install'bam'
  end
end
