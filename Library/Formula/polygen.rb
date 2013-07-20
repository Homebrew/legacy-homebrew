require 'formula'

class Polygen < Formula
  homepage 'http://www.polygen.org'
  url 'http://www.polygen.org/dist/polygen-1.0.6-20040628-src.zip'
  sha1 'a9b397f32f22713c0a98b20c9421815e0a4e1293'

  depends_on 'objective-caml' => :build

  def install
    cd 'src' do
        system 'make'
        bin.install 'polygen'
    end
  end
end
