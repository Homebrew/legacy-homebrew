require 'formula'

class RubyBuild < Formula
  homepage 'https://github.com/sstephenson/ruby-build'
  url 'https://github.com/sstephenson/ruby-build/archive/v20131028.tar.gz'
  sha1 '4fa33cbcc5f84f2e7b4ec160fb3fd5119ad11404'

  head 'https://github.com/sstephenson/ruby-build.git'

  depends_on 'autoconf' => :recommended
  depends_on 'pkg-config' => :recommended

  def install
    ENV['PREFIX'] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/ruby-build --version | grep #{version}"
  end
end
