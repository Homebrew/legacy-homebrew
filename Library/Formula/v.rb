require 'formula'

class V < Formula
  homepage 'https://github.com/rupa/v'
  url 'https://github.com/rupa/v/archive/v1.0.tar.gz'
  sha1 '9e8ce44167a97c10ab41b8fc0e5ec1b2d1cbc4f3'

  head 'https://github.com/rupa/v.git'

  def install
    bin.install 'v'
    man1.install 'v.1'
  end

  def caveats; <<-EOS.undent
    NAME
       v - z for vim

    SYNOPSIS
          v [-a] [-l] [-[0-9]] [--debug] [--help] [regex1 regex2 ... regexn]

    AVAILABILITY
          bash, vim
    EOS
  end
end
