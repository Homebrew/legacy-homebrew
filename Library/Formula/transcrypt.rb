require "formula"

class Transcrypt < Formula
  homepage "https://github.com/elasticdog/transcrypt#readme"
  url "https://github.com/elasticdog/transcrypt/archive/v0.9.4.tar.gz"
  sha1 "e791a1a32aabac7d92b01d0448fa2cf22eb965fc"
  head "https://github.com/elasticdog/transcrypt.git"

  def install
    bin.install "transcrypt"
    man.install "man/transcrypt.1"
    bash_completion.install "contrib/bash/transcrypt"
    zsh_completion.install "contrib/zsh/_transcrypt"
  end
end
