require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/tarball/0.95'
  sha1 '23167626f0744abec7ffa8ecf438765af629703a'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']

    ln_sf opt_prefix, "#{HOMEBREW_PREFIX}/var/lib/rbenv/plugins/#{name}"
  end
end
