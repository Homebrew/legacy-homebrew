require 'formula'

class Go < Formula
  homepage 'http://golang.org'
  version '1.0'
  head 'http://go.googlecode.com/hg/'
  md5 '798bcfc239bf982d7195630cc0b4146b'
  url 'http://go.googlecode.com/files/go.go1.src.tar.gz'

  skip_clean 'bin'

  def install
    prefix.install %w[src include test doc misc lib favicon.ico AUTHORS]
    cd prefix do
      mkdir %w[pkg bin]

      # The version check is due to:
      # http://codereview.appspot.com/5654068
      version = ARGV.build_head? ? 'default' : 'go1'
      File.open('VERSION', 'w') {|f| f.write(version) }

      # Tests take a very long time to run. Build only
      cd 'src' do
        system "./make.bash"
      end
    end
  end
end