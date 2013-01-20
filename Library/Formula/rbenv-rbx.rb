require 'formula'

class RbenvRbx < Formula
  homepage 'https://github.com/rmm5t/rbenv-rbx'
  url 'https://github.com/rmm5t/rbenv-rbx/tarball/v0.1.0'
  sha1 'ef7f52b32faaf5fda5bd47ee33fcf19ef5a8dbe0'

  head 'https://github.com/rmm5t/rbenv-rbx.git'

  depends_on 'rbenv'

  def install
    prefix.install Dir['*']

    ln_sf opt_prefix, "#{HOMEBREW_PREFIX}/var/lib/rbenv/plugins/#{name}"
  end
end
