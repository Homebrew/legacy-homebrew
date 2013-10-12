require 'formula'

class Curaengine < Formula
  homepage 'https://github.com/Ultimaker/CuraEngine'
  url 'https://github.com/Ultimaker/CuraEngine/archive/13.06.3.tar.gz'
  head 'https://github.com/Ultimaker/CuraEngine.git'
  sha1 '74b6053fd1fbfd74eee9f0958d2cbf0cb295bf24'

  def install
    ENV.deparallelize
    system "make"
    bin.install 'CuraEngine'
    system "mv #{bin}/CuraEngine #{bin}/curaengine"
  end

  test do
    system "curaengine"
  end
end
