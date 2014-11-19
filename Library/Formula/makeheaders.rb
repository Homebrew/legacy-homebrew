require 'formula'

class Makeheaders < Formula
  homepage 'http://www.hwaci.com/sw/mkhdr/'
  version '1.4-1'
  sha256 '663c4f5f4579a7b9b7dba49086a33706009b5966d2b669951d5ebee21e411306'
  url "https://github.com/steakknife/makeheaders/archive/#{version}.tar.gz"
  head 'https://github.com/steakknife/makeheaders.git'

  depends_on 'automake' => :build
  depends_on 'autoconf' => :build

  def install
    system './bootstrap'
    system './configure', '--disable-debug',
                          '--disable-dependency-tracking',
                          '--disable-silent-rules',
                          "--prefix=#{prefix}"
    system 'make', 'install'
  end

  test do
    system 'makeheaders'
  end
end

