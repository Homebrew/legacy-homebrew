require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/tarball/0.94'
  sha1 '741477ed78bfbf88f1b010ff8071f95d880793ef'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']

    rbenv_plugins = "#{HOMEBREW_PREFIX}/var/lib/rbenv/plugins"
    mkdir_p rbenv_plugins
    ln_sf opt_prefix, "#{rbenv_plugins}/#{name}"
  end
end
