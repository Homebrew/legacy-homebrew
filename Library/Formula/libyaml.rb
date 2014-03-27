require 'formula'

class Libyaml < Formula
  homepage 'http://pyyaml.org/wiki/LibYAML'
  url 'http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz'
  sha1 'f3d404e11bec3c4efcddfd14c42d46f1aabe0b5d'

  bottle do
    cellar :any
    sha1 "25a60fa0c77710616018e9b5b013916579147338" => :mavericks
    sha1 "311062934d4bd12ef9881f568dbca21d22bbc8c6" => :mountain_lion
    sha1 "69c062b4beccde415c46048dc77a14f480ba31f3" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
