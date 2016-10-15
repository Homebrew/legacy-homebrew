require "formula"

class Antigen < Formula
  homepage "http://antigen.sharats.me/"

  url "https://github.com/tubbo/antigen/archive/install-to-usr-local.tar.gz"
  version "1.1"
  sha1 "f7d3531fd4666bb7f906ba92da4441fdc49b96aa"

  depends_on 'zsh'

  head "https://github.com/tubbo/antigen.git", \
    :branch => "install-to-usr-local",
    :revision => "8aa76cd8b798813775faa563c288fcf4c779ce73"

  def install
    system 'make install'
  end

  def caveats
    <<-TXT

    Add the following to your ~/.zshenv to start using Antigen:

       source #{share}/antigen.zsh

  TXT
  end

  test do
    system "source #{share}/antigen.zsh"
  end
end
