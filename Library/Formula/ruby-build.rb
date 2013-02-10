require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/tarball/v20130208'
  sha1 '66138408b7684c2119df7df4d6ced79ee6820018'

  head 'https://github.com/sstephenson/ruby-build.git'

  option "without-rbenv", "Don't install as an rbenv plugin"

  depends_on 'rbenv' unless build.include? 'without-rbenv'

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"

    unless build.include? 'without-rbenv'
      ln_sf opt_prefix, "#{HOMEBREW_PREFIX}/var/lib/rbenv/plugins/#{name}"
    end
  end
end
