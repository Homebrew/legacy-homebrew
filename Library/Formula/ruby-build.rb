require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/tarball/v20130118'
  sha1 '78c6ad3da88e92acee0b2a5c8ac7462353cf5a8a'

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
