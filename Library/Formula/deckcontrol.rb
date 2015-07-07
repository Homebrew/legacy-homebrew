require 'formula'

class Deckcontrol < Formula
    homepage 'https://github.com/bavc/deckcontrol'
    url "https://github.com/bavc/deckcontrol/archive/v0.2.zip"
    sha256 "b9e12036c164c888fe3c42dabba181cfb0e9ddac3229e735ee48eb5d96811ccc"
    head 'https://github.com/bavc/deckcontrol.git'

    depends_on 'decklinksdk' => :build

    def install
        system "make"
        bin.install 'deckcontrol'
    end
end
