require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/tarball/0.94'
  sha1 '73b1aa192f22571b38d4e110d76f4138c5233c8f'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']

    rbenv_plugins = "#{HOMEBREW_PREFIX}/var/lib/rbenv/plugins"
    mkdir_p rbenv_plugins
    ln_sf opt_prefix, "#{rbenv_plugins}/#{name}"
  end
end
