require 'formula'

class Go < Formula
  homepage 'http://golang.org'
  url 'http://go.googlecode.com/files/go.go1.src.tar.gz'
  version '1'
  sha1 '6023623d083db1980965335b8ac4fa8b428fa484'

  head 'http://go.googlecode.com/hg/'

  skip_clean 'bin'

  def install
    prefix.install Dir['*']

    cd prefix do
      # The version check is due to:
      # http://codereview.appspot.com/5654068
      (Pathname.pwd+'VERSION').write 'default' if ARGV.build_head?

      # Build only. Run `brew test go` to run distrib's tests.
      cd 'src' do
        system './make.bash'
      end
    end
  end

  def test
    cd "#{prefix}/src" do
      system './run.bash --no-rebuild'
    end
  end
end
