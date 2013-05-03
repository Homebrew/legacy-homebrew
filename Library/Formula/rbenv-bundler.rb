require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/archive/0.95.tar.gz'
  sha1 '69485192665caea669a9bc1a86ad225833e3d667'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']

    ln_sf opt_prefix, "#{HOMEBREW_PREFIX}/var/lib/rbenv/plugins/#{name}"
  end

  def caveats; <<-EOS.undent
    rbenv-bundler may cause problems with rbenv including significant slowdown
    of shell initialisation and rehashing.

    Please report any issues with rbenv after installing this plugin here:
    https://github.com/carsomyr/rbenv-bundler/issues/new
    EOS
  end
end
