require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/tarball/1.4.0'
  sha1 '9471ae1df77e561980983e2ae7e7d1f6b74e95bc'

  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  def install
    # fixed in HEAD to respect PREFIX
    inreplace 'Makefile' do |s|
      s.gsub! '/etc/bash_completion.d', "#{prefix}/etc/bash_completion.d"
    end unless ARGV.build_head?

    system "make", "PREFIX=#{prefix}", "install"
  end
end
