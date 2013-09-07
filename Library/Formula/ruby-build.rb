require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/archive/v20130907.tar.gz'
  sha1 'e6c3929745a88f01240f0b9411b7a1b111aa597e'

  head 'https://github.com/sstephenson/ruby-build.git'

  depends_on 'autoconf' => :recommended
  depends_on 'pkg-config' => :recommended

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end
end
