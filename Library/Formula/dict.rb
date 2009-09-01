require 'brewkit'

DICT_CONF=<<-EOS
#  /etc/dict.conf Written by Bob Hilliard <hilliard@debian.org>
#  1998/03/20.  Last revised Sun, 22 Nov 1998 18:10:04 -0500 This is
#  the configuration file for /usr/bin/dict.  In most cases only the
#  server keyword need be specified.

#  This default configuration will try to access a dictd server on the
#  local host, failing that, it will try the public server.  In many
#  cases this will be slow, so you should comment out the line for the
#  server that you don't want to use. To use any other server, enter
#  its IP address in place of "dict.org".

#  Refer to the dict manpage (man dict) for other options that could
#  be inserted in here.

server localhost
server dict.org
EOS

class Dict <Formula
  @url='ftp://ftp.dict.org/dict/dictd-1.9.15.tar.gz'
  @homepage='http://www.dict.org/'
  @md5='68c1cffa952012ba85a7271311de55e9'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--sysconfdir=#{prefix}/etc"

    # install the client
    system "make install.dict"

    # set up the conf file
    (etc+'dict.conf').write DICT_CONF
  end
end
