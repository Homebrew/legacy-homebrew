require 'formula'

class Rbenv < Formula
  homepage 'https://github.com/sstephenson/rbenv'
  url 'https://github.com/sstephenson/rbenv/tarball/v0.3.0'
  sha1 'b9f78b1a10d4e225d0377cac33c1a964ee6df00b'

  head 'https://github.com/sstephenson/rbenv.git'

  # TODO: When we bump the version here we can remove making the plugin
  # directory in depending formulae.
  def install
    prefix.install Dir['*']

    var_lib = "#{HOMEBREW_PREFIX}/var/lib/rbenv/"
    ['plugins', 'versions'].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
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
