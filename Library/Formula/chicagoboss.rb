require 'formula'

class Chicagoboss < Formula
  homepage 'http://www.chicagoboss.org/'
  url 'http://www.chicagoboss.org/ChicagoBoss-0.8.7.tar.gz'
  sha1 'e0ce80562345a0afd2c6df3b3036cd05de21d374'

  option 'with-elixir', "Include Elixir support"

  depends_on "erlang"

  def install
    if build.with? 'elixir'
      inreplace 'rebar.config' do |s|
        s.gsub! /% {elixir,/, '{elixir,'
      end
      copy "priv/web_controller.ex", "src"
    end

    system "./rebar", "get-deps"
    system "./rebar", "compile"
    system "make"

    doc.install "doc-src"
    prefix.install "deps", "ebin", "priv", "skel", "src", "LICENSE", "Makefile", "rebar", "rebar.cmd", "rebar.config", "skel.template"
    info.install Dir["*.md"]
    include.install Dir["include/*"]

    (bin/'boss').write DATA.read
  end

  test do
    system "boss"
  end
end

__END__
#!/usr/bin/env sh
#
# Chicago Boss Executable
#
# @author: Pius Uzamere <pius@alum.mit.edu>
#
# Allows the user to easily create a new Chicago Boss application from anywhere,
# as long as the Chicago Boss directory is in the user's path.

working_directory="$PWD"
init_script="$working_directory/init.sh"

# Find the actual directory of Chicago Boss, even if the binary is symlinked.

pushd . > /dev/null
bossdir="${BASH_SOURCE[0]}";
if ([ -h "${bossdir}" ]) then
while([ -h "${bossdir}" ]) do cd `dirname "$bossdir"`; bossdir=`readlink "${bossdir}"`; done
fi
cd `dirname ${bossdir}` > /dev/null
bossdir=`pwd`;
popd > /dev/null
cd "$bossdir/.."
bossdir=$PWD

case "${1:-''}" in
  'new')
    if [ $# -eq 2 ]
    then
echo "Hold on tight, creating new Chicago Boss app $2 ..."
      make app PROJECT=$2 PREFIX="$working_directory/" -f "$bossdir/Makefile"
    else
echo Please specify an app name to create a new Chicago Boss application.
      echo "Usage: boss new APP_NAME or boss start|start-dev|stop|reload|restart|attach"
    fi
    ;;

  'start'|'start-dev'|'stop'|'reload'|'restart'|'attach')
    if [ -f $init_script ]
    then
sh $init_script $1
    else
echo Sorry, \"boss $1\" may only be run from the root directory of a Chicago Boss application.
    fi
    ;;

  *)
    echo "Chicago Boss."
    echo "Usage: boss new APP_NAME or boss start|start-dev|stop|reload|restart|attach"
    exit 1
    ;;
esac
