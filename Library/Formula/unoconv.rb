require "formula"

class Unoconv < Formula
  homepage "http://dag.wiee.rs/home-made/unoconv/"
  url "http://dag.wieers.com/home-made/unoconv/unoconv-0.6.tar.gz"
  sha1 "d6c3574639b9ceedcb866b84f18ba7158f25db48"
  head "https://github.com/dagwieers/unoconv.git"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    In order to use unoconv LibreOffice 3.6.0.1 or later must be installed.
    EOS
  end
end
