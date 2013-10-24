require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/archive/v20131024.tar.gz'
  sha1 '2b6adef4914ae24965b696a38e4ba131fdb321fb'

  head 'https://github.com/sstephenson/ruby-build.git'

  depends_on 'autoconf' => :recommended
  depends_on 'pkg-config' => :recommended

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
