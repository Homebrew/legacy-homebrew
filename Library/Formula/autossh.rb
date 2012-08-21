require 'formula'

class Autossh < Formula
  homepage 'http://www.harding.motd.ca/autossh/'
  url 'http://www.harding.motd.ca/autossh/autossh-1.4c.tgz'
  md5 '26520eea934f296be0783dabe7fcfd28'

  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
    mv (bin+"autossh"), (bin+"autossh.real")
    (bin+"autossh").write(autossh_wrapper)
    bin.install 'rscreen'
  end

  def autossh_wrapper; <<-EOS.undent
    #!/bin/sh
    # little wrapper to choose a random port for autossh
    # falling back to $fallback_port

    set -u

    autossh_bin=${AUTOSSH_BIN:-#{HOMEBREW_PREFIX}/bin/autossh.real}
    fallback_port=${AUTOSSH_FALLBACK_PORT:-21021}

    # XXX what if these are not available?
    egrep=$(command -v egrep)
    lsof=$(command -v lsof)
    od=$(command -v od)
    tr=$(command -v tr)

    # backwards compatibility, skip guess if -M is passed
    echo "$@" | $egrep -q -- '-f?M ?[0-9]+'
    if [ $? -eq 0 ] || [ -n "${AUTOSSH_PORT:-}" ]; then
        exec $autossh_bin "$@"
    fi

    # take an int port and check whether it is in use (i.e. locally bound)
    # unix command semantics: if in use return 0 else return 1
    port_in_use() {
        [ -z "$1" ] && return 0

        $lsof -i tcp:$1 -s tcp:listen -Fp 1>/dev/null
        free_all=$?

        $lsof -i tcp@127.0.0.1:$1 -s tcp:listen -Fp 1>/dev/null
        free_localhost=$?

        [ $free_all -eq 0 ] || [ $free_localhost -eq 0 ]
        return $?
    }

    portguess=""
    if [ -r "/dev/urandom" ]; then
        for t in $(seq 1 42); do
            # get a random int for the tcp port
            randport=$( $od -i -N2 -An /dev/urandom | $tr -d ' ' )
            randport_1=$(( $randport + 1 ))

            [ "$randport" -le 1024 ] && continue
            [ "$randport" -ge 65535 ] && continue

            # check if port is in use, race condition between here
            # and the exec
            if ! port_in_use $randport && ! port_in_use $randport_1; then
                portguess=$randport
                break
            fi
        done
    fi

    if [ -z "$portguess" ]; then
        fallback=$fallpack_port
        fallback_1=$(( $fallback_port + 1 ))
        if ! port_in_use $fallback && ! port_in_use $fallback_1; then
            portguess=$fallback_port
        else
            echo "unable to find a suitable tunnel port"
            exit 1
        fi
    fi

    export AUTOSSH_PORT="$portguess"

    exec $autossh_bin "$@"
    EOS
  end
end


__END__
diff --git a/rscreen b/rscreen
index f0bbced..ce232c3 100755
--- a/rscreen
+++ b/rscreen
@@ -23,4 +23,4 @@ fi
 #AUTOSSH_PATH=/usr/local/bin/ssh
 export AUTOSSH_POLL AUTOSSH_LOGFILE AUTOSSH_DEBUG AUTOSSH_PATH AUTOSSH_GATETIME AUTOSSH_PORT
 
-autossh -M 20004 -t $1 "screen -e^Zz -D -R"
+autossh -M 20004 -t $1 "screen -D -R"
