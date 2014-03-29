require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.16/1.16.6/+download/juju-core_1.16.6.tar.gz'
  sha1 '0483d7a4d3fda0981f822d540cded855eb5afbda'

  bottle do
    sha1 "06dec5a1342231cc7721cb6afcb51ea0604ffa8c" => :mavericks
    sha1 "04c65a325c275c66b490684daca7342ef5f7220a" => :mountain_lion
    sha1 "80c65027bcb4ac3b11d39232d27171816236856a" => :lion
  end

  devel do
    url  'https://launchpad.net/juju-core/trunk/1.17.7/+download/juju-core_1.17.7.tar.gz'
    sha1 '7dc39b3e9291cc62f78065af19bce68a81f25421'
  end

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    args = %w(install launchpad.net/juju-core/cmd/juju)
    args.insert(1, "-v") if ARGV.verbose?
    system "go", *args
    bin.install 'bin/juju'
    (bash_completion/'juju-completion.bash').write <<-EOS.undent
    _juju()
    {
        local cur prev options files targets
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        actions=$(juju help commands 2>/dev/null | awk '{print $1}')
        COMPREPLY=( $( compgen -W "${actions}" -- ${cur} ) )
        return 0
    }
    complete -F _juju juju
    EOS
  end

  test do
    system "#{bin}/juju", "version"
  end
end
