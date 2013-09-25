require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/archive/v20130923.tar.gz'
  sha1 '7d5f5392892f125ef2f8dc49083622e3751fdc7a'

  head 'https://github.com/sstephenson/ruby-build.git'

  depends_on 'autoconf' => :recommended
  depends_on 'pkg-config' => :recommended

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
