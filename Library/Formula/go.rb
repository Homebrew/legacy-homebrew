require 'formula'

class Go < Formula
  homepage 'http://golang.org'
  url 'http://go.googlecode.com/files/go1.0.3.src.tar.gz'
  version '1.0.3'
  sha1 '1a67293c10d6c06c633c078a7ca67e98c8b58471'

  head 'http://go.googlecode.com/hg/'

  skip_clean 'bin'

  def install
    # install the completion script
    (prefix/'etc/bash_completion.d').install 'misc/bash/go' => 'go-completion.bash'

    prefix.install Dir['*']

    cd prefix do
      # The version check is due to:
      # http://codereview.appspot.com/5654068
      (prefix/'VERSION').write 'default' if build.head?

      # Build only. Run `brew test go` to run distrib's tests.
      cd 'src' do
        system './make.bash'
      end
    end

    # Don't install header files; they aren't necessary and can
    # cause problems with other builds. See:
    # http://trac.macports.org/ticket/30203
    # http://code.google.com/p/go/issues/detail?id=2407
    include.rmtree
  end

  def test
    cd "#{prefix}/src" do
      system './run.bash --no-rebuild'
    end
  end
end
