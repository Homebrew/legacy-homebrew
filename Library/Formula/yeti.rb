require 'formula'

class Yeti < Formula
  homepage 'http://mth.github.io/yeti/'
  url 'https://github.com/mth/yeti/archive/v0.9.9.tar.gz'
  sha1 'd4b3fee9e9e1c117f1a73b147695a24a217c2658'

  head 'https://github.com/mth/yeti.git'

  depends_on :ant => :build

  def install
    system "ant jar"
    libexec.install "yeti.jar"
    bin.write_jar_script libexec/"yeti.jar", "yeti", "-server"
  end
end
