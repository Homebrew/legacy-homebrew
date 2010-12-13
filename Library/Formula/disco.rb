require 'formula'

class Disco <Formula
  homepage 'http://discoproject.com/'
  url 'git://github.com/tuulos/disco.git', :tag => '0.3.1'
  # Periods in the install path cause disco-worker to complain so change to underscores.
  version '0_3_1'
  head 'git://github.com/tuulos/disco.git'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MACOS_VERSION < 10.6
  depends_on 'libcmph'

  def install
    inreplace "Makefile", "DESTDIR=/", "DESTDIR=#{prefix}"
    inreplace "Makefile", "PREFIX=/usr/local", "PREFIX="
    inreplace "Makefile", "DISCO_ROOT = $(DESTDIR)/srv/disco/", "DISCO_ROOT = #{var}/disco/"

    # add some helpful config for local development
    inreplace "conf/gen.settings.sys-Darwin", "${DESTDIR}", HOMEBREW_PREFIX
    inreplace "conf/gen.settings.sys-Darwin", "DDFS_TAG_MIN_REPLICAS = 3", "DDFS_TAG_MIN_REPLICAS = 1"
    inreplace "conf/gen.settings.sys-Darwin", "DDFS_TAG_REPLICAS     = 3", "DDFS_TAG_REPLICAS     = 1"
    inreplace "conf/gen.settings.sys-Darwin", "DDFS_BLOB_REPLICAS    = 3", "DDFS_BLOB_REPLICAS    = 1\n" +
              "DISCO_MASTER_HOST = 'localhost'\n" +
              "DISCODEX_HOME = os.path.join(os.path.dirname(DISCO_HOME), 'discodex')"

    system "make"
    system "make install"
    ENV.delete('CC')
    system "make install-discodb install-discodex"
    bin.install('contrib/discodex/bin/discodex')
    bin.install('contrib/discodex/bin/discodexcli.py')
    prefix.install Dir['node']
    prefix.install Dir['examples']
    prefix.install Dir['contrib']
    prefix.install Dir['doc']
  end

  def caveats
    s = <<-EOS.undent
      Please symlink #{etc}/disco/settings.py to ~/.disco and edit accordingly:
      $ ln -s #{etc}/disco/settings.py ~/.disco

      To run the discodex server for development:
      $ cd #{prefix}/contrib/discodex/www
      $ ./manage.py runserver 8080

      DDFS_*_REPLICA settings have been set to 1 assuming a single-machine install.
      Please see http://discoproject.org/doc/start/install.html for further instructions.
    EOS
    return s
  end
end
