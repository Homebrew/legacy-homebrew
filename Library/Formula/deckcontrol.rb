require 'formula'

class Deckcontrol < Formula
    homepage 'https://github.com/bavc/deckcontrol'
    url "https://github.com/bavc/deckcontrol/archive/v0.3.zip"
    sha256 "6d84028726abc4f68c0b122a48cfea261e6bbe8e642ca66a71285ccb500c4933"
    head 'https://github.com/bavc/deckcontrol.git'

    depends_on 'decklinksdk' => :build

    def install
        system "make"
        bin.install 'deckcontrol'
    end
end
