require 'formula'

class Disco < Formula
  homepage 'http://discoproject.com/'
  url 'https://github.com/tuulos/disco/tarball/0.3.2'
  md5 '47a740b84ef61cea8ba3644610e25083'
  # Periods in the install path cause disco-worker to complain so change to underscores.
  version '0_3_2'
  head 'https://github.com/tuulos/disco.git'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MacOS.leopard?
  depends_on 'libcmph'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "DESTDIR", prefix
      s.change_make_var! "PREFIX", ""
      s.change_make_var! "DISCO_ROOT", "#{var}/disco/"
    end

    # add some helpful config for local development
    inreplace "conf/gen.settings.sys-Darwin" do |s|
     s.gsub! "${DESTDIR}", HOMEBREW_PREFIX
     s.gsub! "DDFS_TAG_MIN_REPLICAS = 3", "DDFS_TAG_MIN_REPLICAS = 1"
     s.gsub! "DDFS_TAG_REPLICAS     = 3", "DDFS_TAG_REPLICAS     = 1"
     s.gsub! "DDFS_BLOB_REPLICAS    = 3", "DDFS_BLOB_REPLICAS    = 1\n" +
              "DISCO_MASTER_HOST = 'localhost'\n" +
              "DISCODEX_HOME = os.path.join(os.path.dirname(DISCO_HOME), 'discodex')"
    end

    system "make"
    system "make install"
    ENV.delete('CC')
    system "make install-discodb install-discodex"
    bin.install ['contrib/discodex/bin/discodex','contrib/discodex/bin/discodexcli.py']
    prefix.install ['contrib', 'doc', 'examples', 'node']
  end

  def caveats; <<-EOS.undent
    Please symlink #{etc}/disco/settings.py to ~/.disco and edit accordingly:
        ln -s #{etc}/disco/settings.py ~/.disco

    To run the discodex server for development:
        cd #{prefix}/contrib/discodex/www
        ./manage.py runserver 8080

    The DDFS_*_REPLICA settings have been set to 1 assuming a single-machine install.
    Please see http://discoproject.org/doc/start/install.html for further instructions.
    EOS
  end
end
