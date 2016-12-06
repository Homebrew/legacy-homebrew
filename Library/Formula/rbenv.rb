require 'formula'

class Rbenv < Formula
  url 'https://github.com/sstephenson/rbenv/zipball/v0.1.0'
  homepage 'https://github.com/sstephenson/rbenv'
  head 'https://github.com/sstephenson/rbenv.git', :using => :git

  def install
    prefix.install Dir['*']
  end

  def caveats
    <<-CAVEATS.undent
      Now, add this to your bash (or zsh) profile:
        eval "$(rbenv init -)"
      or add shims to your PATH manually:
        export PATH="#{prefix}/shims:$PATH"
      and restart your shell:
        exec

      Then install some rubies to:
        ~/.rbenv/versions

      You might like to use ruby-build (available in homebrew):
        ruby-build 1.9.2-p290 ~/.rbenv/versions/1.9.2-p290

      Finally, rebuild the shim binaries when you install a new ruby or a gem providing a binary:
        rbenv rehash
    CAVEATS
  end
end
