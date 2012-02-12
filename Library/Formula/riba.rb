require 'formula'

class Riba < Formula
  url 'https://github.com/ashwinr/Riba.git', :using => :git
  homepage 'https://github.com/ashwinr/Riba'
  md5 '0ee6430fb39afed8f2a2267bc8bd47c5'
  depends_on 'leveldb' => :build
  version '0.1'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "LDFLAGS", "-lleveldb -lreadline -lsnappy"
    end
    system "make"
    bin.install "riba"
  end

  def test
    system "riba"
  end
end
