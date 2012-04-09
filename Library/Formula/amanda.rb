require 'formula'

# this formula was created by Nathaniel Madura (nmadura at umich dot edu)
# It is to make an Amanda (community edition) backup client for OS X
# Amanda runs a specific user, instructions for creating that user on 
# a 10.5+ machine are included in the caveats.

class Amanda < Formula
  homepage 'http://amanda.org/'
  url 'http://downloads.sourceforge.net/project/amanda/amanda%20-%20stable/3.3.1/amanda-3.3.1.tar.gz'
  md5 'dae7631b4abcf7eac874df6e3740e75b'

  depends_on 'glib'
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'cairo' if ARGV.include? '--with-gnuplot'

  def options
     [
        ['--with-gnuplot', "Enable amanda plotting module."],
     ]
  end

  def install
#    ENV.append "PKG_CONFIG", "#{HOMEBREW_PREFIX}/bin/pkg-config"

    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking",
            # specify user and group to run amanda as, see caveats below
            "--with-user=amandabackup",
            "--with-group=admin",
            "--with-ssh-security",
            # this is the client package, unknow if OS X can be installed with a server package
            "--without-server",
            # amanda typically installs perl scripts, for the time being I am hiding these in the
            # cellar.
            "--without-amperldir"]

    # cairo, or one of its dependencies does not appear to be installing on PPC
    if ARGV.include? '--with-gnuplot'
        args << "-I#{Formula.factory('cairo').lib}"
        args << "-I#{Formula.factory('cairo').include}"
    end

    system "./configure", *args
    system "make"
    # amanda wants setuid root
    system "echo 'This package requires setuid root on amservice.'"
    system "sudo make install"
  end

  def caveats
    puts <<BEGIN
Issue the following to create the correct user account
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
