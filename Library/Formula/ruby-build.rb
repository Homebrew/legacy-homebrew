require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/archive/v20131008.tar.gz'
  sha1 '4122735f4b6a5c5c5179f2374cd82a9da8005f2e'

  head 'https://github.com/sstephenson/ruby-build.git'

  depends_on 'autoconf' => :recommended
  depends_on 'pkg-config' => :recommended

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
