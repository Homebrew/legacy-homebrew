require 'formula'

class Pyenv < Formula
  homepage 'https://github.com/yyuu/pyenv'
  url 'https://github.com/yyuu/pyenv/tarball/v0.1.2'
  sha1 '6703b7044d64814bed6003074c0f8be8c11504d1'

  head 'https://github.com/yyuu/pyenv.git'

  def install
    prefix.install Dir['*']

    var_lib = "#{HOMEBREW_PREFIX}/var/lib/pyenv"
    ['plugins','versions'].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end
  end

  def caveats; <<-EOS.undent
    To enabled shims and autocompletion add to your profile:
      if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

    To use Homebrew's directories rather than ~/.pyenv add to your profile:
      export PYENV_ROOT=#{opt_prefix}
    EOS
  end
end
