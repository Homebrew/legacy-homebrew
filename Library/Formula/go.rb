require 'formula'

class Go < Formula
  homepage 'http://golang.org'
  url 'http://go.googlecode.com/files/go1.0.1.src.tar.gz'
  version '1.0.1'
  sha1 'fc8a6d6725f7f2bf7c94685c5fd0880c9b7f67f6'

  head 'http://go.googlecode.com/hg/'

  skip_clean 'bin'

  def install
    prefix.install Dir['*']

    cd prefix do
      # The version check is due to:
      # http://codereview.appspot.com/5654068
      (prefix/'VERSION').write 'default' if ARGV.build_head?

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
