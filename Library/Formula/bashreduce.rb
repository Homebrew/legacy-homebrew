require 'formula'

class Bashreduce <Formula
  head 'git://github.com/erikfrey/bashreduce.git'
  homepage 'https://github.com/erikfrey/bashreduce'

  def install
    Dir.chdir 'brutils' do
      inreplace "Makefile" do |s|
        s.change_make_var! 'CFLAGS', ENV.cflags
        s.change_make_var! 'BINDIR', bin
      end

      system "make"
      bin.install "brp"
      bin.install "brm"
    end

    bin.install "br"
  end
end
