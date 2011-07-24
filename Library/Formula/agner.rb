require 'formula'

class Agner < Formula
  head "https://github.com/agner/agner.git", :branch => "master"
  homepage 'http://erlagner.org/'

  depends_on 'erlang'

  def install
    system "make"
    system "./agner install agner"
  end
end
