require "formula"

class Transcrypt < Formula
  homepage "https://github.com/elasticdog/transcrypt#README"
  url "https://github.com/elasticdog/transcrypt/archive/v0.9.4.tar.gz"
  sha1 "8467e221b6f8a30eb335b97fb52a4bd555fc958e"

  def install
    bin.install "transcrypt"
    man.install "man/transcrypt.1"
    bash_completion.install "contrib/bash/transcrypt"
    zsh_completion.install "contrib/zsh/_transcrypt"
  end
end
