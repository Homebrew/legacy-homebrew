# smu homebrew
require 'formula'

class Smu < Formula
      homepage 'http://s01.de/~tox/index.cgi/proj_smu'
      url 'http://s01.de/~tox/files/smu/smu-1.2.tar.gz'
      md5 '7862a62c80cfe0a2ac9b9f74cb3bce77'

      def install
        system 'make smu'
        system 'make install'
      end

      def test
        system "echo 'foo' | smu"
      end
end

