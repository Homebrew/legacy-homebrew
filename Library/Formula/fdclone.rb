require 'formula'

class Fdclone < Formula
  homepage 'http://hp.vector.co.jp/authors/VA012337/soft/fd/'
  url 'http://hp.vector.co.jp/authors/VA012337/soft/fd/FD-3.01a.tar.gz'
  sha1 '5d4f90ccaee67fadcc5d776f90bbe2fd760c4cdd'

  depends_on 'nkf' => :build

  def install
    ENV.j1
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "MANTOP=#{man}", "install"

    %w(README FAQ HISTORY LICENSES TECHKNOW ToAdmin).each do |file|
      system "nkf", "-w", "--overwrite", file
      prefix.install "#{file}.eng" => file
      prefix.install file => "#{file}.ja"
    end

    share.install "_fdrc" => "fd2rc.dist"
  end

  def caveats; <<-EOS.undent
    To install the initial config file:
        install -c -m 0644 #{share}/fd2rc.dist ~/.fd2rc
    EOS
  end
end
