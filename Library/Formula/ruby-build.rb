require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/archive/v20131115.tar.gz'
  sha1 '19e215947d115445bc73caa6163388fdefb7e823'

  head 'https://github.com/sstephenson/ruby-build.git'

  depends_on 'autoconf' => [:recommended, :run]
  depends_on 'pkg-config' => [:recommended, :run]
  depends_on 'libyaml' => :recommended
  depends_on 'openssl' => :optional

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/ruby-build --version | grep #{version}"
  end
end
