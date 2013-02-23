require 'formula'

class RbenvBundler < Formula
  homepage 'https://github.com/carsomyr/rbenv-bundler'
  url 'https://github.com/carsomyr/rbenv-bundler/tarball/0.95'
  sha1 '68f34b7d9e123d93f51fe5fcca585fdaf3cd31e7'

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
