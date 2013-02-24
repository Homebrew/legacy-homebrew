require 'formula'

class Libyaml < Formula
  homepage 'http://pyyaml.org/wiki/LibYAML'
  url 'http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz'
  sha1 'e0e5e09192ab10a607e3da2970db492118f560f2'

  option :universal

  def install
    args = ["--prefix=#{prefix}"]

    if build.universal?
      ENV.universal_binary
      args << "--disable-dependency-tracking"
    end

    system './configure', *args
    system "make install"
  end
end
