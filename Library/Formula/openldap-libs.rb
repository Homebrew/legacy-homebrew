require 'formula'

class OpenldapLibs < Formula
  url 'ftp://ftp.OpenLDAP.org/pub/OpenLDAP/openldap-stable/openldap-stable-20100719.tgz'
  homepage 'http://www.openldap.org/'
  md5 '90150b8c0d0192e10b30157e68844ddf'
  version '2.4.23'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}",
                          "--disable-slapd", "--disable-slurpd"

    # empty Makefiles to prevent unnecessary installation attempts
    makefile = "all:\ninstall:\n"
    unwanted_paths = ['clients', 'servers', 'tests', 'doc']
    unwanted_paths.each do |upath|
      File.open(Dir.getwd + '/' + upath + '/Makefile', 'w') {|f| f.write(makefile)}
    end

    system "make install"
    File.rename("#{prefix}/etc/openldap/ldap.conf", "#{prefix}/etc/openldap/ldap.conf.backup")
    File.symlink('/etc/openldap/ldap.conf', "#{prefix}/etc/openldap/ldap.conf")
  end
end
