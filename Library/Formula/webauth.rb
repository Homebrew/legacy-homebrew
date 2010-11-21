require 'formula'

class Webauth <Formula
  url 'http://webauth.stanford.edu/dist/webauth-3.7.3.tar.gz'
  homepage 'http://webauth.stanford.edu/'
  md5 '15c1dc3217e51b55bd2e77856ae7e0e0'

  def install
    (prefix+'krb5.conf').write krb5_conf
    system './configure', "--prefix=#{prefix}", "--libexecdir=#{lib}", "KRB5_CONFIG=#{prefix}/krb5.conf", "--disable-dependency-tracking"
    system 'make install'
  end
  
  def caveats; <<-EOS
If this is your first install, please copy the file in #{prefix}/krb5.conf to /etc/krb5.conf with the following command:
    sudo cp #{prefix}/krb5.conf /etc/krb5.conf
EOS
  end
  
  def krb5_conf
    return <<-EOS
# /etc/krb5.conf -- Kerberos V5 general configuration.
# $Id: krb5.conf 2205 2009-01-08 19:39:45Z rra $
#
# This is the Stanford-wide default Kerberos v5 configuration file.  The
# canonical location of this file is /usr/pubsw/etc/krb5.conf.  To request
# a realm be added to this file, please submit a HelpSU ticket.
#
# This configuration allows any enctypes.  Some systems with really old
# Kerberos software may have to limit to triple-DES and DES.

[appdefaults]
    default_lifetime      = 25hrs
    krb4_get_tickets      = false
    krb4_convert          = false
    krb4_convert_524      = false
    krb5_get_tickets      = true
    krb5_get_forwardable  = true

    stanford.edu = {
        aklog_path        = /usr/bin/aklog
        krb_run_aklog     = true
    }

    pam = {
        minimum_uid       = 100
        search_k5login    = true
        forwardable       = true
    }

    pam-afs-session = {
        minimum_uid       = 100
    }

    libkafs = {
        IR.STANFORD.EDU = {
            afs-use-524   = no
        }
    }

    passwd_change = {
        passwd_file       = /afs/ir.stanford.edu/service/etc/passwd.all
        server            = password-change.stanford.edu
        port              = 4443
        service_principal = service/password-change@stanford.edu
    }

    wallet = {
        wallet_server     = wallet.stanford.edu
    }

[libdefaults]
    default_realm         = stanford.edu
    ticket_lifetime       = 25h
    renew_lifetime        = 7d
    forwardable           = true
    noaddresses           = true

[realms]
    stanford.edu = {
        kdc            = krb5auth1.stanford.edu:88
        kdc            = krb5auth2.stanford.edu:88
        kdc            = krb5auth3.stanford.edu:88
        master_kdc     = krb5auth1.stanford.edu:88
        admin_server   = krb5-admin.stanford.edu
        default_domain = stanford.edu
        kadmind_port   = 749
    }
    WIN.STANFORD.EDU = {
        kdc            = mothra.win.stanford.edu:88
        kdc            = rodan.win.stanford.edu:88
        kpasswd_server = mothra.win.stanford.edu
    }
    MS.STANFORD.EDU = {
        kdc            = msdc0.ms.stanford.edu:88
        kdc            = msdc1.ms.stanford.edu:88
        kpasswd_server = msdc0.ms.stanford.edu
    }
    NT.STANFORD.EDU = {
        kdc            = ntdc2.nt.stanford.edu:88
        kdc            = ntdc3.nt.stanford.edu:88
        kpasswd_server = ntdc2.nt.stanford.edu
    }
    GUEST.STANFORD.EDU = {
        kdc            = guestdc0.guest.stanford.edu:88
        kdc            = guestdc1.guest.stanford.edu:88
        kpasswd_server = guestdc0.guest.stanford.edu
        default_domain = guest.stanford.edu
    }
    GUESTUAT.STANFORD.EDU = {
        kdc            = guestuatdc0.guestuat.stanford.edu:88
        kdc            = guestuatdc1.guestuat.stanford.edu:88
        kpasswd_server = guestuatdc0.guestuat.stanford.edu
        default_domain = guestuat.stanford.edu
    }
    CS.STANFORD.EDU = {
        kdc            = cs-kdc-1.stanford.edu:88
        kdc            = cs-kdc-2.stanford.edu:88
        kdc            = cs-kdc-3.stanford.edu:88
        admin_server   = cs-kdc-1.stanford.edu:749
    }
    SLAC.STANFORD.EDU = {
        kdc            = k5auth1.slac.stanford.edu:88
        kdc            = k5auth2.slac.stanford.edu:88
        kdc            = k5auth3.slac.stanford.edu:88
        admin_server   = k5admin.slac.stanford.edu
        kpasswd_server = k5passwd.slac.stanford.edu
        default_domain = slac.stanford.edu
    }
    WIN.SLAC.STANFORD.EDU = {
        kdc            = winmaster2.win.slac.stanford.edu
        default_domain = win.slac.stanford.edu
    }
    ATHENA.MIT.EDU = {
        kdc            = kerberos.mit.edu:88
        kdc            = kerberos-1.mit.edu:88
        kdc            = kerberos-2.mit.edu:88
        kdc            = kerberos-3.mit.edu:88
        admin_server   = kerberos.mit.edu
        default_domain = mit.edu
    }
    ISC.ORG = {
        kdc            = k1.isc.org:88
        kdc            = k2.isc.org:88
        admin_server   = k1.isc.org:749
        default_domain = isc.org
    }
    OPENLDAP.ORG = {
        kdc            = kerberos.openldap.org
        default_domain = openldap.org
    }
    SUCHDAMAGE.ORG = {
        kdc            = kerberos.suchdamage.org:88
        admin_server   = kerberos.suchdamage.org:749
        default_domain = suchdamage.org
    }
    VIX.COM = {
        kdc            = kerberos-0.vix.com:88
        kdc            = kerberos-1.vix.com:88
        kdc            = kerberos-2.vix.com:88
        admin_server   = kerberos-0.vix.com:749
        default_domain = vix.com
    }
    ZEPA.NET = {
        kdc            = kerberos.zepa.net
        kdc            = kerberos-too.zepa.net
        admin_server   = kerberos.zepa.net
    }

[domain_realm]
    stanford.edu                = stanford.edu
    .stanford.edu               = stanford.edu
    .dc.stanford.org            = stanford.edu
    .sunet                      = stanford.edu
    .eyrie.org                  = stanford.edu
    .oit.duke.edu               = stanford.edu
    win.stanford.edu            = WIN.STANFORD.EDU
    .win.stanford.edu           = WIN.STANFORD.EDU
    daper.stanford.edu          = IT.WIN.STANFORD.EDU
    gsbworkspace.stanford.edu   = IT.WIN.STANFORD.EDU
    infraappprod.stanford.edu   = IT.WIN.STANFORD.EDU
    radmed.stanford.edu         = IT.WIN.STANFORD.EDU
    windows.stanford.edu        = IT.WIN.STANFORD.EDU
    workspace.stanford.edu      = IT.WIN.STANFORD.EDU
    ms.stanford.edu             = MS.STANFORD.EDU
    .ms.stanford.edu            = MS.STANFORD.EDU
    nt.stanford.edu             = NT.STANFORD.EDU
    .nt.stanford.edu            = NT.STANFORD.EDU
    guest.stanford.edu          = GUEST.STANFORD.EDU
    .guest.stanford.edu         = GUEST.STANFORD.EDU
    guest-mgmt.stanford.edu     = GUEST.STANFORD.EDU
    guestidmweb.stanford.edu    = GUEST.STANFORD.EDU
    guestuat.stanford.edu       = GUESTUAT.STANFORD.EDU
    .guestuat.stanford.edu      = GUESTUAT.STANFORD.EDU
    guestuat-mgmt.stanford.edu  = GUESTUAT.STANFORD.EDU
    guestuatidmweb.stanford.edu = GUESTUAT.STANFORD.EDU
    .slac.stanford.edu          = SLAC.STANFORD.EDU
    .isc.org                    = ISC.ORG
    mit.edu                     = ATHENA.MIT.EDU
    .mit.edu                    = ATHENA.MIT.EDU
    openldap.org                = OPENLDAP.ORG
    .openldap.org               = OPENLDAP.ORG
    whoi.edu                    = ATHENA.MIT.EDU
    .whoi.edu                   = ATHENA.MIT.EDU
    .vix.com                    = VIX.COM
    zepa.net                    = ZEPA.NET
    .zepa.net                   = ZEPA.NET

[logging]
    kdc          = SYSLOG:NOTICE
    admin_server = SYSLOG:NOTICE
    default      = SYSLOG:NOTICE
EOS
  end
end