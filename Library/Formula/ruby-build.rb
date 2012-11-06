require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/tarball/v20121104'
  sha1 'edda42338e7a6e35ff4f185079962d38c74a65f4'

  head 'https://github.com/sstephenson/ruby-build.git'

  option "without-rbenv", "Don't install as an rbenv plugin"

  depends_on 'rbenv' unless build.include? 'without-rbenv'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"

    rbenv_plugins = "#{HOMEBREW_PREFIX}/var/lib/rbenv/plugins"
    mkdir_p rbenv_plugins
    ln_sf opt_prefix, "#{rbenv_plugins}/#{name}" unless build.include? 'without-rbenv'
  end
end
