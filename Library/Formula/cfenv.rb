require 'formula'

class Cfenv < Formula
  homepage 'https://github.com/joshuairl/cfenv'
  url 'https://github.com/joshuairl/cfenv/archive/v0.0.5.tar.gz'
  sha1 '16ad2b4e81d996cf9051371c6954d9010712e90a'

  head 'https://github.com/joshuairl/cfenv.git'

  def install
    inreplace 'libexec/cfenv', '/usr/local', HOMEBREW_PREFIX
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To use Homebrew's directories rather than ~/.cfenv add to your profile:
      export CFENV_ROOT=#{var}/cfenv

    To enable shims and autocompletion add to your profile:
      if which cfenv > /dev/null; then eval "$(cfenv init -)"; fi

    Other than that, enjoy using cfenv!
    You should now be able to type cfenv to explore it's features.
    EOS
  end
end
