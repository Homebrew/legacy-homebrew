require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/tarball/v20121201'
  sha1 '2376fe7cc68eb6cfdd2cb8b7f9319cb7795a40a0'

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
