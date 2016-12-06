require 'formula'

class Asciinema < Formula
  homepage 'http://asciinema.org'
  url 'https://github.com/sickill/asciinema/archive/v0.9.5.tar.gz'
  sha1 '902893a524eaab7794eb04b5092b4b78c3c4c622'

  depends_on :python => "2.7"

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end
end
