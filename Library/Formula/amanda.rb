require 'formula'

class Amanda < Formula
  homepage 'http://amanda.org/'
  url 'http://downloads.sourceforge.net/project/amanda/amanda%20-%20stable/3.3.1/amanda-3.3.1.tar.gz'
  md5 'dae7631b4abcf7eac874df6e3740e75b'

  depends_on 'glib'
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gnuplot' if ARGV.include? '--with-amplot'

  def options
     [
        ['--with-amplot', "Enable amanda plotting module."],
     ]
  end

  def install
    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--disable-dependency-tracking",
            "--disable-installperms",
            # specify user and group to run amanda as, see caveats below
            "--with-user=amandabackup",
            "--with-group=admin",
            "--with-ssh-security",
            # this is the client package, unknow if OS X can be installed with a server package
            "--without-server",
            # amanda typically installs perl scripts, for the time being I am hiding these in the
            # cellar.
            "--without-amperldir"]

    # gnuplot pulls in libgd and a bunch of other dependencies, and plotting by the client isn't necessary
    if ARGV.include? '--with-amplot'
      args << "--with-gnuplot=#{Formula.factory('gnuplot').bin}"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats
    <<BEGIN
1.
amservice typically installs with setuid root, this has been disabled to comply with homebrew

2.
The username/group that amanda runs as is compiled into the package, they are amandabackup/admin
Issue the following to create the correct user account:

sudo dscl localhost -create /Local/Default/Users/amandabackup
sudo dscl localhost -create /Local/Default/Users/amandabackup RecordName amandabackup
sudo dscl localhost -create /Local/Default/Users/amandabackup UserShell /bin/bash
sudo dscl localhost -create /Local/Default/Users/amandabackup RealName "Backup User"
sudo dscl localhost -create /Local/Default/Users/amandabackup UniqueID 5000
sudo dscl localhost -create /Local/Default/Users/amandabackup PrimaryGroupID 0
sudo dscl localhost -append /Local/Default/Groups/admin GroupMembership amandabackup
sudo dscl localhost -create /Local/Default/Users/amandabackup NFSHomeDirectory /Users/amandabackup
sudo ditto -rsrcFork '/System/Library/User Template/English.lproj/' /Users/amandabackup
sudo sh -c "echo 'amandabackup_server.example.com amandabackup' > /Users/amandabackup/.amandahosts"
sudo chmod 600 /Users/amandabackup/.amandahosts
sudo chown -R amandabackup:wheel /Users/amandabackup
sudo passwd amandabackup
BEGIN
  end
end
