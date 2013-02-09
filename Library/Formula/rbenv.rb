require 'formula'

class Rbenv < Formula
  homepage 'https://github.com/sstephenson/rbenv'
  url 'https://github.com/sstephenson/rbenv/tarball/v0.4.0'
  sha1 'a5e80249f985294c1c9f0914f7cbdc85d4cadd74'

  head 'https://github.com/sstephenson/rbenv.git'

  def install
    prefix.install Dir['*']

    var_lib = var/'lib/rbenv'
    ['plugins', 'versions'].each do |dir|
      var_dir = var_lib/dir
      var_dir.mkpath
      ln_sf var_dir, (prefix/dir)
    end
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

    To use Homebrew's directories rather than ~/.rbenv add to your profile:
      export RBENV_ROOT=#{opt_prefix}
    EOS
  end
end
