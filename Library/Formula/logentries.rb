require 'formula'

class Logentries < Formula
  homepage 'https://github.com/logentries/le'
  url 'https://github.com/logentries/le/tarball/v0.8.20'
  head 'https://github.com/logentries/le.git'
  md5 '18a52860b3f32eb75e508b7e8ff49cf0'

  def install
    inreplace 'le', "usage: le COMMAND [ARGS]", "usage: logentries COMMAND [ARGS]"
    bin.install 'le' => 'logentries'
  end

  def test
    banner = `logentries 2>&1`
    banner =~ /.*Logentries/
  end
end
