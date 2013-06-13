require 'formula'

class Pyenv < Formula
  homepage 'https://github.com/yyuu/pyenv'
  url 'https://github.com/yyuu/pyenv/archive/v0.4.0-20130613.tar.gz'
  sha1 '58fab2ac96b66583299be48394b3dece2eb84155'

  head 'https://github.com/yyuu/pyenv.git'

  skip_clean "plugins", "versions"

  def install
    prefix.install "LICENSE", "README.md", "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    var_lib = "#{HOMEBREW_PREFIX}/var/lib/pyenv"
    ['plugins', 'versions'].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    ln_sf "#{prefix}/default-plugins/python-build", "#{var_lib}/plugins/python-build"
    ["pyenv-install", "pyenv-uninstall", "python-build"].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/python-build/bin/#{cmd}"
    end
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

    To use Homebrew's directories rather than ~/.pyenv add to your profile:
      export PYENV_ROOT=#{opt_prefix}
    EOS
  end
end
