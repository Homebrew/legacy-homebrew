require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/archive/v20131220.tar.gz'
  sha1 'a078d8f8e1722a8cd9c5df6636c74d0ac6e0926f'

  head 'https://github.com/sstephenson/ruby-build.git'

  depends_on 'autoconf' => [:recommended, :run]
  depends_on 'pkg-config' => [:recommended, :run]
  depends_on 'openssl' => :recommended

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/ruby-build --version | grep #{version}"
  end
end
